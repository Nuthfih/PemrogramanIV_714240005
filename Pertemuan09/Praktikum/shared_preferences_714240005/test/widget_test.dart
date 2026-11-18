import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_714240005/main.dart';

void main() {
  testWidgets(
    'Login validation shows error messages when inputs are too short',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), 'abc');
      await tester.enterText(find.byType(TextFormField).at(1), '12');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.text('Masukkan minimal 4 karakter'), findsOneWidget);
      expect(find.text('Masukkan minimal 3 karakter'), findsOneWidget);
      expect(find.text('Shared Preference'), findsOneWidget);
    },
  );

  testWidgets(
    'Login navigates to DynamicBottomNavBar, Shared Preferences tab works, and Logout clears username',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), 'ULBI Juara');
      await tester.enterText(find.byType(TextFormField).at(1), '123456');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Home tab is active with username displayed
      expect(find.text('Welcome to Home'), findsOneWidget);
      expect(find.text('ULBI Juara'), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);

      // Switch to Shared Preferences tab
      await tester.tap(find.text('Shared Preferences'));
      await tester.pumpAndSettle();

      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Get Value'), findsOneWidget);
      expect(find.text('Delete Value'), findsOneWidget);

      await tester.enterText(find.byType(TextField).at(0), 'Halo Flutter');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Get Value'));
      await tester.pumpAndSettle();

      final readFieldAfterSave = tester.widget<TextField>(
        find.byType(TextField).at(1),
      );
      expect(readFieldAfterSave.controller?.text, 'Halo Flutter');

      await tester.tap(find.text('Delete Value'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Get Value'));
      await tester.pumpAndSettle();

      final readFieldAfterDelete = tester.widget<TextField>(
        find.byType(TextField).at(1),
      );
      expect(readFieldAfterDelete.controller?.text, 'null');

      // Switch back to Home tab and Logout
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();

      expect(find.text('Shared Preference'), findsOneWidget);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('login'), true);
      expect(prefs.getString('username'), isNull);
    },
  );

  testWidgets(
    'Auto-login redirects to DynamicBottomNavBar when login is false',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'login': false,
        'username': 'ULBI Juara',
      });

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('Welcome to Home'), findsOneWidget);
      expect(find.text('ULBI Juara'), findsOneWidget);
    },
  );
}
