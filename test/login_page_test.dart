//WIDGET TEST for "Does the login screen form validation work correctly when the form is submitted empty?"

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import 'package:cs_310_project/views/login_register/login_register.dart';
import 'package:cs_310_project/views/login_register/login_register_provider.dart';

class MockLoginRegisterProvider extends Mock implements LoginRegisterProvider {}

void main() {
  testWidgets('LoginPage shows validation errors when submitted empty',
          (WidgetTester tester) async {
        final mockProvider = MockLoginRegisterProvider();

        when(() => mockProvider.loading).thenReturn(false);
        when(() => mockProvider.error).thenReturn(null);

        when(() => mockProvider.login(any(), any())).thenAnswer((_) async => false);
        when(() => mockProvider.register(any(), any())).thenAnswer((_) async => false);

        await tester.pumpWidget(
          ChangeNotifierProvider<LoginRegisterProvider>.value(
            value: mockProvider,
            child: const MaterialApp(
              home: LoginPage(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final logInBtn = find.text('Log In');
        final loginBtn = find.text('Login');

        if (logInBtn.evaluate().isNotEmpty) {
          await tester.tap(logInBtn);
        } else {
          await tester.tap(loginBtn);
        }

        await tester.pumpAndSettle();

        expect(find.text('Invalid Input'), findsOneWidget);
        expect(find.textContaining('Please fix the form errors'), findsOneWidget);
        expect(find.text('Email required'), findsOneWidget);
        expect(find.text('Password required'), findsOneWidget);
      });
}

