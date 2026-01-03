import 'package:flutter_test/flutter_test.dart';

import 'package:eco_track_flutter/core/utils/extensions.dart';

void main() {
  group('StringExtensions', () {
    test('isValidEmail returns true for valid emails', () {
      expect('test@example.com'.isValidEmail, isTrue);
      expect('user.name@domain.co.uk'.isValidEmail, isTrue);
      expect('user+tag@example.com'.isValidEmail, isTrue);
    });

    test('isValidEmail returns false for invalid emails', () {
      expect('invalid-email'.isValidEmail, isFalse);
      expect('@example.com'.isValidEmail, isFalse);
      expect('user@'.isValidEmail, isFalse);
      expect(''.isValidEmail, isFalse);
    });

    test('capitalize capitalizes first letter', () {
      expect('hello'.capitalize, 'Hello');
      expect('HELLO'.capitalize, 'HELLO');
      expect(''.capitalize, '');
    });
  });

  group('DateTimeExtensions', () {
    test('startOfDay returns beginning of day', () {
      final date = DateTime(2024, 1, 15, 14, 30, 45);
      final startOfDay = date.startOfDay;
      expect(startOfDay.hour, 0);
      expect(startOfDay.minute, 0);
      expect(startOfDay.second, 0);
    });

    test('endOfDay returns end of day', () {
      final date = DateTime(2024, 1, 15, 14, 30, 45);
      final endOfDay = date.endOfDay;
      expect(endOfDay.hour, 23);
      expect(endOfDay.minute, 59);
      expect(endOfDay.second, 59);
    });

    test('isToday returns true for today', () {
      final today = DateTime.now();
      expect(today.isToday, isTrue);
    });

    test('isToday returns false for yesterday', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      expect(yesterday.isToday, isFalse);
    });
  });
}


