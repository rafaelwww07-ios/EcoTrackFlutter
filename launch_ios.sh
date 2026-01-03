
#!/bin/bash

# Script to launch iOS simulator and run Flutter app

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

echo "🍎 Запуск iOS симулятора и приложения EcoTrack..."
echo ""

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode не установлен"
    echo ""
    echo "💡 Установите Xcode:"
    echo "   1. Откройте App Store"
    echo "   2. Найдите и установите Xcode"
    echo "   3. После установки выполните:"
    echo "      sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer"
    echo "      sudo xcodebuild -runFirstLaunch"
    exit 1
fi

echo "✅ Xcode найден"

# Check if CocoaPods is installed
if ! command -v pod &> /dev/null; then
    echo "⚠️  CocoaPods не установлен"
    echo "   Установка CocoaPods..."
    sudo gem install cocoapods 2>&1 | tail -3 || {
        echo "❌ Не удалось установить CocoaPods"
        echo "   Установите вручную: sudo gem install cocoapods"
        exit 1
    }
fi

echo "✅ CocoaPods установлен"

# Install iOS dependencies
echo ""
echo "📦 Установка iOS зависимостей..."
cd ios
pod install 2>&1 | tail -5
cd ..

# Check if simulator is already running
if flutter devices 2>&1 | grep -q "ios"; then
    echo "✅ iOS симулятор уже запущен"
    IOS_DEVICE=$(flutter devices 2>&1 | grep ios | head -1 | awk '{print $5}')
    echo "   Устройство: $IOS_DEVICE"
else
    echo "📱 Запуск iOS симулятора..."
    open -a Simulator > /dev/null 2>&1
    
    echo "⏳ Ожидание загрузки симулятора..."
    
    # Wait for simulator to start
    for i in {1..30}; do
        if flutter devices 2>&1 | grep -q "ios"; then
            IOS_DEVICE=$(flutter devices 2>&1 | grep ios | head -1 | awk '{print $5}')
            echo "✅ Симулятор запущен! Устройство: $IOS_DEVICE"
            break
        fi
        sleep 2
        if [ $((i % 5)) -eq 0 ]; then
            echo "   Ожидание... ($i секунд)"
        fi
    done
fi

# Check if we have an iOS device
if ! flutter devices 2>&1 | grep -q "ios"; then
    echo "❌ Не удалось запустить iOS симулятор"
    echo ""
    echo "💡 Попробуйте вручную:"
    echo "   1. Откройте Xcode"
    echo "   2. Xcode → Open Developer Tool → Simulator"
    echo "   3. Выберите устройство (например, iPhone 15)"
    echo "   4. Затем запустите: flutter run"
    exit 1
fi

IOS_DEVICE=$(flutter devices 2>&1 | grep ios | head -1 | awk '{print $5}')

echo ""
echo "🚀 Запуск приложения на iOS симуляторе $IOS_DEVICE..."
echo ""

# Run the app
flutter run -d "$IOS_DEVICE"

