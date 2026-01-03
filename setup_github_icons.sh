#!/bin/bash

# Script to set up social preview images for all GitHub repositories
# GitHub automatically uses .github/social-preview.png as the social preview image

set -e

GITHUB_USER="rafaelwww07-ios"
TEMP_DIR="/tmp/github_icons_setup"
REPOS=(
    "EcoTrackFlutter"
    "GitHubUsersAndroid"
    "HabitTrackerAndroid"
    "FinanceFlowAndroid"
    "HabitTracker"
    "FinanceFlow"
    "GitHubUsers"
)

echo "🎨 Установка иконок для репозиториев GitHub..."
echo ""

# Create temp directory
mkdir -p "$TEMP_DIR"

# Function to find icon in repository
find_icon() {
    local repo_path="$1"
    local icon_path=""
    
    # Common icon locations
    local possible_paths=(
        "assets/icons/app_icon.png"
        "assets/icons/icon.png"
        "assets/icon.png"
        "assets/app_icon.png"
        "app/src/main/res/mipmap-xxxhdpi/ic_launcher.png"
        "app/src/main/res/mipmap-xxhdpi/ic_launcher.png"
        "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png"
        "macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_512.png"
        "macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_1024.png"
        "web/favicon.png"
        "favicon.png"
        "icon.png"
        "logo.png"
    )
    
    for path in "${possible_paths[@]}"; do
        if [ -f "$repo_path/$path" ]; then
            # Check if it's a real image file
            if file "$repo_path/$path" | grep -qE "(PNG|JPEG|GIF|image)"; then
                icon_path="$repo_path/$path"
                break
            fi
        fi
    done
    
    echo "$icon_path"
}

# Function to process repository
process_repo() {
    local repo_name="$1"
    local repo_url="https://github.com/${GITHUB_USER}/${repo_name}.git"
    local repo_path="$TEMP_DIR/$repo_name"
    
    echo "📦 Обрабатываю: $repo_name"
    
    # Clone or update repository
    if [ -d "$repo_path" ]; then
        echo "   Обновляю репозиторий..."
        cd "$repo_path"
        git pull --quiet || true
    else
        echo "   Клонирую репозиторий..."
        git clone --depth 1 "$repo_url" "$repo_path" --quiet
    fi
    
    # Find icon
    local icon=$(find_icon "$repo_path")
    
    if [ -z "$icon" ]; then
        echo "   ⚠️  Иконка не найдена, пропускаю..."
        return
    fi
    
    echo "   ✅ Найдена иконка: $icon"
    
    # Create .github directory
    mkdir -p "$repo_path/.github"
    
    # Copy icon to .github/social-preview.png
    # Resize to 1280x640 if needed (GitHub recommended size)
    if command -v sips >/dev/null 2>&1; then
        # macOS: use sips to resize
        sips -z 640 1280 "$icon" --out "$repo_path/.github/social-preview.png" >/dev/null 2>&1 || \
        cp "$icon" "$repo_path/.github/social-preview.png"
    elif command -v convert >/dev/null 2>&1; then
        # Linux: use ImageMagick
        convert "$icon" -resize 1280x640 "$repo_path/.github/social-preview.png" 2>/dev/null || \
        cp "$icon" "$repo_path/.github/social-preview.png"
    else
        # Just copy if no resize tool available
        cp "$icon" "$repo_path/.github/social-preview.png"
    fi
    
    echo "   ✅ Иконка установлена в .github/social-preview.png"
    
    # Commit and push
    cd "$repo_path"
    if git diff --quiet .github/social-preview.png 2>/dev/null; then
        echo "   ℹ️  Изменений нет, пропускаю коммит"
    else
        git add .github/social-preview.png
        git commit -m "Add social preview image" --quiet || true
        git push origin main --quiet || git push origin master --quiet || true
        echo "   ✅ Изменения отправлены на GitHub"
    fi
    
    echo ""
}

# Process current repository first (EcoTrackFlutter)
echo "🎯 Обрабатываю текущий репозиторий (EcoTrackFlutter)..."
CURRENT_DIR="$(pwd)"
if [ -f "macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_512.png" ]; then
    mkdir -p .github
    cp macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_512.png .github/social-preview.png
    echo "✅ Иконка установлена для текущего репозитория"
    git add .github/social-preview.png
    git commit -m "Add social preview image" --quiet || true
    git push origin main --quiet || true
    echo "✅ Изменения отправлены на GitHub"
    echo ""
fi

# Process other repositories
for repo in "${REPOS[@]}"; do
    if [ "$repo" != "EcoTrackFlutter" ]; then
        process_repo "$repo"
    fi
done

# Cleanup
echo "🧹 Очистка временных файлов..."
rm -rf "$TEMP_DIR"

echo "✅ Готово! Все иконки установлены."

