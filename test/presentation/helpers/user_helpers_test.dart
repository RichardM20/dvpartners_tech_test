import 'package:flutter_test/flutter_test.dart';

import 'package:dvpartners_tech_test/presentation/helpers/user_helpers.dart';

void main() {
  group('UserHelpers', () {
    group('calculateAge', () {
      test('should calculate age correctly for person born today', () {
        final today = DateTime.now();
        final birthDate = DateTime(today.year - 25, today.month, today.day);

        final age = UserHelpers.calculateAge(birthDate);

        expect(age, equals(25));
      });

      test(
        'should calculate age correctly for person with birthday not yet passed',
        () {
          final today = DateTime.now();
          final birthDate = DateTime(
            today.year - 25,
            today.month + 1,
            today.day,
          );

          final age = UserHelpers.calculateAge(birthDate);

          expect(age, equals(24));
        },
      );

      test(
        'should calculate age correctly for person with birthday already passed',
        () {
          final today = DateTime.now();
          final birthDate = DateTime(
            today.year - 25,
            today.month - 1,
            today.day,
          );

          final age = UserHelpers.calculateAge(birthDate);

          expect(age, equals(25));
        },
      );

      test('should handle leap year correctly', () {
        final birthDate = DateTime(2000, 2, 29);

        final age = UserHelpers.calculateAge(birthDate);

        expect(age, greaterThan(20));
      });
    });

    group('formatAddressCount', () {
      test('should return "Sin direcciones" for count 0', () {
        final result = UserHelpers.formatAddressCount(0);

        expect(result, equals('Sin direcciones'));
      });

      test('should return "1 dirección" for count 1', () {
        final result = UserHelpers.formatAddressCount(1);

        expect(result, equals('1 dirección'));
      });

      test('should return "X direcciones" for count greater than 1', () {
        final result = UserHelpers.formatAddressCount(3);

        expect(result, equals('3 direcciones'));
      });

      test('should handle large numbers', () {
        final result = UserHelpers.formatAddressCount(100);

        expect(result, equals('100 direcciones'));
      });
    });

    group('formatBirthDate', () {
      test('should format date correctly with leading zeros', () {
        final birthDate = DateTime(1990, 1, 5);

        final result = UserHelpers.formatBirthDate(birthDate);

        expect(result, equals('05/01/1990'));
      });

      test('should format date correctly for single digit day and month', () {
        final birthDate = DateTime(1985, 3, 7);

        final result = UserHelpers.formatBirthDate(birthDate);

        expect(result, equals('07/03/1985'));
      });

      test('should format date correctly for double digit day and month', () {
        final birthDate = DateTime(2000, 12, 25);

        final result = UserHelpers.formatBirthDate(birthDate);

        expect(result, equals('25/12/2000'));
      });
    });

    group('getInitials', () {
      test('should return first letter for single name', () {
        final result = UserHelpers.getInitials('Juan');

        expect(result, equals('J'));
      });

      test('should return first two letters for two names', () {
        final result = UserHelpers.getInitials('Juan Pérez');

        expect(result, equals('JP'));
      });

      test('should return first two letters for multiple names', () {
        final result = UserHelpers.getInitials('Juan Carlos Pérez García');

        expect(result, equals('JC'));
      });

      test('should handle empty string', () {
        final result = UserHelpers.getInitials('');

        expect(result, equals('U'));
      });

      test('should handle string with only spaces', () {
        final result = UserHelpers.getInitials('   ');

        expect(result, equals('U'));
      });

      test('should handle names with extra spaces', () {
        final result = UserHelpers.getInitials('  Juan   Pérez  ');

        expect(result, equals('JP'));
      });

      test('should handle lowercase names', () {
        final result = UserHelpers.getInitials('juan pérez');

        expect(result, equals('JP'));
      });

      test('should handle mixed case names', () {
        final result = UserHelpers.getInitials('jUaN pÉrEz');

        expect(result, equals('JP'));
      });
    });
  });
}
