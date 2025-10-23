import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dvpartners_tech_test/domain/entities/user.dart';
import 'package:dvpartners_tech_test/presentation/widgets/user_card/user_card.dart';

void main() {
  group('UserCard', () {
    late User testUser;

    setUp(() {
      testUser = User(
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
    });

    testWidgets('should display user information correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: UserCard(user: testUser)),
        ),
      );

      expect(find.text('Juan Pérez'), findsOneWidget);
      expect(find.text('1 dirección'), findsOneWidget);
      expect(find.text('Nacido: 01/01/1990'), findsOneWidget);
      expect(find.text('JP'), findsOneWidget);
    });

    testWidgets('should display multiple addresses correctly', (tester) async {
      final userWithMultipleAddresses = testUser.copyWith(
        addresses: [
          testUser.addresses.first,
          const Address(
            id: 2,
            userId: 1,
            country: 'México',
            department: 'Jalisco',
            municipality: 'Guadalajara',
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: UserCard(user: userWithMultipleAddresses)),
        ),
      );

      expect(find.text('2 direcciones'), findsOneWidget);
    });

    testWidgets('should display no addresses correctly', (tester) async {
      final userWithoutAddresses = testUser.copyWith(addresses: []);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: UserCard(user: userWithoutAddresses)),
        ),
      );

      expect(find.text('Sin direcciones'), findsOneWidget);
    });

    testWidgets('should display user initials in avatar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: UserCard(user: testUser)),
        ),
      );

      expect(find.text('JP'), findsOneWidget);
    });

    testWidgets('should display correct initials for single name', (
      tester,
    ) async {
      final userWithSingleName = testUser.copyWith(lastName: '');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: UserCard(user: userWithSingleName)),
        ),
      );

      expect(find.text('J'), findsOneWidget);
    });

    testWidgets('should have proper card styling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: UserCard(user: testUser)),
        ),
      );

      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should display location icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: UserCard(user: testUser)),
        ),
      );

      expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);
    });

    testWidgets('should display cake icon for birth date', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: UserCard(user: testUser)),
        ),
      );

      expect(find.byIcon(Icons.cake_outlined), findsOneWidget);
    });
  });
}
