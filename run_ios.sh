#!/bin/bash

# Script to run Flutter app on iOS simulator without UUID issues

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

echo "🍎 Запуск EcoTrack на iOS..."
echo ""

# Check if simulator is running
if ! flutter devices 2>&1 | grep -q "ios.*simulator"; then
    echo "⚠️  iOS симулятор не запущен"
    echo "   Запускаю симулятор..."
    open -a Simulator > /dev/null 2>&1
    
    echo "⏳ Ожидание загрузки симулятора..."
    sleep 5
fi

# Clean build
echo "🧹 Очистка кэша..."
flutter clean > /dev/null 2>&1

# Get dependencies
echo "📦 Получение зависимостей..."
flutter pub get > /dev/null 2>&1

# Build and run without specifying device ID
# Flutter will automatically select the running simulator
echo ""
echo "🚀 Запуск приложения..."
echo "   Flutter автоматически выберет запущенный симулятор"
echo ""

# Run without device ID - Flutter will auto-select
flutter run

