import 'package:flutter_test/flutter_test.dart';

import 'package:dvpartners_tech_test/domain/entities/user.dart';

void main() {
  group('Address', () {
    test('should create address with all properties', () {
      const address = Address(
        id: 1,
        userId: 1,
        country: 'Colombia',
        department: 'Bogotá D.C.',
        municipality: 'Bogotá',
      );

      expect(address.id, equals(1));
      expect(address.userId, equals(1));
      expect(address.country, equals('Colombia'));
      expect(address.department, equals('Bogotá D.C.'));
      expect(address.municipality, equals('Bogotá'));
    });

    test('should support equality comparison', () {
      const address1 = Address(
        id: 1,
        userId: 1,
        country: 'Colombia',
        department: 'Bogotá D.C.',
        municipality: 'Bogotá',
      );

      const address2 = Address(
        id: 1,
        userId: 1,
        country: 'Colombia',
        department: 'Bogotá D.C.',
        municipality: 'Bogotá',
      );

      const address3 = Address(
        id: 2,
        userId: 1,
        country: 'Colombia',
        department: 'Bogotá D.C.',
        municipality: 'Bogotá',
      );

      expect(address1, equals(address2));
      expect(address1, isNot(equals(address3)));
    });

    test('should support copyWith method', () {
      const originalAddress = Address(
        id: 1,
        userId: 1,
        country: 'Colombia',
        department: 'Bogotá D.C.',
        municipality: 'Bogotá',
      );

      final updatedAddress = originalAddress.copyWith(
        country: 'México',
        department: 'Jalisco',
        municipality: 'Guadalajara',
      );

      expect(updatedAddress.id, equals(1));
      expect(updatedAddress.userId, equals(1));
      expect(updatedAddress.country, equals('México'));
      expect(updatedAddress.department, equals('Jalisco'));
      expect(updatedAddress.municipality, equals('Guadalajara'));
    });
  });

  group('User', () {
    test('should create user with all properties', () {
      final user = User(
        id: 1,
        firstName: 'Juan',
        lastName: 'Pérez',
        birthDate: DateTime(1990, 1, 1),
        addresses: [
          const Address(
            id: 1,
            userId: 1,
            country: 'Colombia',
            department: 'Bogotá D.C.',
            municipality: 'Bogotá',
          ),
        ],
      );

      expect(user.id, equals(1));
      expect(user.firstName, equals('Juan'));
      expect(user.lastName, equals('Pérez'));
      expect(user.birthDate, equals(DateTime(1990, 1, 1)));
      expect(user.addresses.length, equals(1));
    });

    test('should return full name correctly', () {
      final user = User(
        id: 1,
        firstName: 'Juan',
        lastName: 'Pérez',
        birthDate: DateTime(1990, 1, 1),
        addresses: [],
      );

      expect(user.fullName, equals('Juan Pérez'));
    });

    test('should support equality comparison', () {
      final user1 = User(
        id: 1,
        firstName: 'Juan',
        lastName: 'Pérez',
        birthDate: DateTime(1990, 1, 1),
        addresses: [],
      );

      final user2 = User(
        id: 1,
        firstName: 'Juan',
        lastName: 'Pérez',
        birthDate: DateTime(1990, 1, 1),
        addresses: [],
      );

      final user3 = User(
        id: 2,
        firstName: 'Juan',
        lastName: 'Pérez',
        birthDate: DateTime(1990, 1, 1),
        addresses: [],
      );

      expect(user1, equals(user2));
      expect(user1, isNot(equals(user3)));
    });

    test('should support copyWith method', () {
      final originalUser = User(
        id: 1,
        firstName: 'Juan',
        lastName: 'Pérez',
        birthDate: DateTime(1990, 1, 1),
        addresses: [],
      );

      final updatedUser = originalUser.copyWith(
        firstName: 'Juan Carlos',
        lastName: 'García',
      );

      expect(updatedUser.id, equals(1));
      expect(updatedUser.firstName, equals('Juan Carlos'));
      expect(updatedUser.lastName, equals('García'));
      expect(updatedUser.birthDate, equals(DateTime(1990, 1, 1)));
      expect(updatedUser.addresses, isEmpty);
    });

    test('should handle multiple addresses', () {
      final user = User(
        id: 1,
        firstName: 'Juan',
        lastName: 'Pérez',
        birthDate: DateTime(1990, 1, 1),
        addresses: [
          const Address(
            id: 1,
            userId: 1,
            country: 'Colombia',
            department: 'Bogotá D.C.',
            municipality: 'Bogotá',
          ),
          const Address(
            id: 2,
            userId: 1,
            country: 'México',
            department: 'Jalisco',
            municipality: 'Guadalajara',
          ),
        ],
      );

      expect(user.addresses.length, equals(2));
      expect(user.addresses[0].country, equals('Colombia'));
      expect(user.addresses[1].country, equals('México'));
    });
  });
}
