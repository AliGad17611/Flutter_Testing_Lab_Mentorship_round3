import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

void main() {
  group('Unit Tests for validation logic', () {
    test('isValidEmail', () {
      expect(UserRegistrationForm.isValidEmail('test@test.com'), isTrue);
      expect(UserRegistrationForm.isValidEmail('test@test'), isFalse);
      expect(UserRegistrationForm.isValidEmail('test@test.c'), isFalse);
      expect(UserRegistrationForm.isValidEmail('test@test.co'), isFalse);
      expect(UserRegistrationForm.isValidEmail('test@test.com'), isTrue);
    });

    test('isValidPassword', () {
      expect(UserRegistrationForm.isValidPassword('Password123!'), isTrue);
      expect(UserRegistrationForm.isValidPassword('Password123'), isFalse);
      expect(UserRegistrationForm.isValidPassword('password123!'), isFalse);
      expect(UserRegistrationForm.isValidPassword('password123!'), isFalse);
    });
  });
  group('Widget Tests for form submission', () {
    late UserRegistrationForm form;
    setUp(() {
      form = UserRegistrationForm();
    });
    testWidgets('should validate form fields', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: form)));
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
    });
    testWidgets('should show Registration successful! when form is submitted with valid fields', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: form)));

      await tester.enterText(find.byType(TextFormField).first, 'John Doe');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'john.doe@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(2), 'Password123!');
      await tester.enterText(find.byType(TextFormField).at(3), 'Password123!');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.text('Registration successful!'), findsOneWidget);
    });
    testWidgets('should show Please correct the errors in the form. when form is submitted with invalid fields', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: form)));
      await tester.enterText(find.byType(TextFormField).first, 'John Doe');
      await tester.enterText(find.byType(TextFormField).at(1), 'john.doe@example.com');
      await tester.enterText(find.byType(TextFormField).at(2), 'Password123');
      await tester.enterText(find.byType(TextFormField).at(3), 'Password123!');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.text('Please correct the errors in the form.'), findsOneWidget);
    });
  });
}
