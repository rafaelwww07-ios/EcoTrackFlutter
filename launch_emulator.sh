#!/bin/bash

# Script to launch Android emulator and run Flutter app

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

echo "🚀 Запуск Android эмулятора и приложения Eco Track..."
echo ""

# Check if emulator is already running
if flutter devices 2>&1 | grep -q "android"; then
    echo "✅ Эмулятор уже запущен"
    EMULATOR_ID=$(flutter devices 2>&1 | grep android | awk '{print $5}' | head -1)
    echo "   ID: $EMULATOR_ID"
else
    echo "📱 Запуск эмулятора..."
    flutter emulators --launch Medium_Phone_API_36.1 > /dev/null 2>&1 &
    
    echo "⏳ Ожидание загрузки эмулятора (это может занять 1-2 минуты)..."
    
    # Wait for emulator to start
    for i in {1..60}; do
        if flutter devices 2>&1 | grep -q "android"; then
            EMULATOR_ID=$(flutter devices 2>&1 | grep android | awk '{print $5}' | head -1)
            echo "✅ Эмулятор запущен! ID: $EMULATOR_ID"
            break
        fi
        sleep 2
        if [ $((i % 10)) -eq 0 ]; then
            echo "   Ожидание... ($i секунд)"
        fi
    done
fi

# Check if we have an emulator
if ! flutter devices 2>&1 | grep -q "android"; then
    echo "❌ Не удалось запустить эмулятор"
    echo ""
    echo "💡 Попробуйте вручную:"
    echo "   1. Откройте Android Studio"
    echo "   2. Tools → Device Manager"
    echo "   3. Запустите эмулятор"
    echo "   4. Затем запустите: flutter run"
    exit 1
fi

EMULATOR_ID=$(flutter devices 2>&1 | grep android | awk '{print $5}' | head -1)

echo ""
echo "🚀 Запуск приложения на эмуляторе $EMULATOR_ID..."
echo ""

# Run the app
flutter run -d "$EMULATOR_ID"

