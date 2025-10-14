import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/user_registration_form.dart';

void main() {
  group('User Registration Form', () {
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
}
