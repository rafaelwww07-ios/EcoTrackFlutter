import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:eco_track_flutter/features/home/presentation/pages/home_page.dart';
import 'package:eco_track_flutter/features/auth/presentation/bloc/auth_bloc.dart';

void main() {
  group('HomePage Widget Tests', () {
    testWidgets('HomePage displays bottom navigation bar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (context) => AuthBloc(),
            child: const HomePage(),
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Calculator'), findsOneWidget);
      expect(find.text('Map'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('HomePage switches tabs when navigation item is tapped',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (context) => AuthBloc(),
            child: const HomePage(),
          ),
        ),
      );

      // Tap on Calculator tab
      await tester.tap(find.text('Calculator'));
      await tester.pumpAndSettle();

      // Verify calculator icon is selected
      expect(find.byIcon(Icons.calculate), findsWidgets);
    });
  });
}


