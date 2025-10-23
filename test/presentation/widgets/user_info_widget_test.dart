import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dvpartners_tech_test/domain/entities/user.dart';
import 'package:dvpartners_tech_test/presentation/widgets/user_info_widget.dart';

void main() {
  group('UserInfoWidget', () {
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
          home: Scaffold(body: UserInfoWidget(user: testUser)),
        ),
      );

      expect(find.text('Juan Pérez'), findsOneWidget);
      expect(find.text('ID: 1'), findsOneWidget);
      expect(find.text('JP'), findsOneWidget);
    });

    testWidgets('should display formatted birth date', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: UserInfoWidget(user: testUser)),
        ),
      );

      expect(find.text('01/01/1990'), findsOneWidget);
    });

    testWidgets('should display calculated age', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: UserInfoWidget(user: testUser)),
        ),
      );

      expect(find.textContaining('años'), findsOneWidget);
    });

    testWidgets('should display address count', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: UserInfoWidget(user: testUser)),
        ),
      );

      expect(find.text('1 dirección'), findsOneWidget);
    });

    testWidgets('should display correct initials in avatar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: UserInfoWidget(user: testUser)),
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
          home: Scaffold(body: UserInfoWidget(user: userWithSingleName)),
        ),
      );

      expect(find.text('J'), findsOneWidget);
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
          home: Scaffold(body: UserInfoWidget(user: userWithMultipleAddresses)),
        ),
      );

      expect(find.text('2 direcciones'), findsOneWidget);
    });

    testWidgets('should display no addresses correctly', (tester) async {
      final userWithoutAddresses = testUser.copyWith(addresses: []);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: UserInfoWidget(user: userWithoutAddresses)),
        ),
      );

      expect(find.text('Sin direcciones'), findsOneWidget);
    });

    testWidgets('should have proper card styling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: UserInfoWidget(user: testUser)),
        ),
      );

      expect(find.byType(Container), findsWidgets);
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.borderRadius, equals(BorderRadius.circular(16)));
      expect(decoration.color, equals(Colors.white));
      expect(decoration.boxShadow, isNotEmpty);
    });

    testWidgets('should display all required icons', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: UserInfoWidget(user: testUser)),
        ),
      );

      expect(find.byIcon(Icons.cake_outlined), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today_outlined), findsOneWidget);
      expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);
    });

    testWidgets('should have correct avatar styling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: UserInfoWidget(user: testUser)),
        ),
      );

      final avatarContainer = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(Container),
              matching: find.byType(Container),
            )
            .first,
      );

      final decoration = avatarContainer.decoration as BoxDecoration;
      expect(decoration.borderRadius, equals(BorderRadius.circular(100)));
      expect(decoration.boxShadow, isNotEmpty);
    });
  });
}
