#!/bin/bash

# Script to run Eco Track Flutter app
# This script will check for errors and run the app

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

echo "🚀 Запуск Eco Track приложения..."
echo ""

# Check Flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter не установлен"
    exit 1
fi

echo "✅ Flutter найден: $(flutter --version | head -1)"
echo ""

# Get dependencies
echo "📦 Получение зависимостей..."
flutter pub get > /dev/null 2>&1
echo "✅ Зависимости готовы"
echo ""

# Check devices
echo "📱 Проверка устройств..."
DEVICES=$(flutter devices 2>&1 | grep -E "• (android|ios|macos|chrome)" | head -1)

if [ -z "$DEVICES" ]; then
    echo "⚠️  Устройства не найдены"
    echo "   Запуск на первом доступном устройстве..."
    DEVICE=""
else
    DEVICE_ID=$(echo "$DEVICES" | awk '{print $5}')
    echo "✅ Найдено устройство: $DEVICE_ID"
    DEVICE="-d $DEVICE_ID"
fi

echo ""
echo "🚀 Запуск приложения..."
echo ""

# Run the app
flutter run $DEVICE

