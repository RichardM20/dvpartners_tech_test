import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dvpartners_tech_test/domain/entities/user.dart';
import 'package:dvpartners_tech_test/presentation/widgets/address/address_card.dart';

void main() {
  group('AddressCardWidget', () {
    late Address testAddress;

    setUp(() {
      testAddress = const Address(
        id: 1,
        userId: 1,
        country: 'Colombia',
        department: 'Bogotá D.C.',
        municipality: 'Bogotá',
      );
    });

    testWidgets('should display address information correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddressCardWidget(number: 1, address: testAddress),
          ),
        ),
      );

      expect(find.text('Dirección 1'), findsOneWidget);
      expect(find.text('País:'), findsOneWidget);
      expect(find.text('Colombia'), findsOneWidget);
      expect(find.text('Departamento:'), findsOneWidget);
      expect(find.text('Bogotá D.C.'), findsOneWidget);
      expect(find.text('Municipio:'), findsOneWidget);
      expect(find.text('Bogotá'), findsOneWidget);
    });

    testWidgets('should display correct address number', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddressCardWidget(number: 3, address: testAddress),
          ),
        ),
      );

      expect(find.text('Dirección 3'), findsOneWidget);
    });

    testWidgets('should display "No especificado" for empty values', (
      tester,
    ) async {
      final emptyAddress = const Address(
        id: 1,
        userId: 1,
        country: '',
        department: '',
        municipality: '',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddressCardWidget(number: 1, address: emptyAddress),
          ),
        ),
      );

      expect(find.text('No especificado'), findsNWidgets(3));
    });

    testWidgets('should have proper card styling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddressCardWidget(number: 1, address: testAddress),
          ),
        ),
      );

      expect(find.byType(Container), findsWidgets);
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.borderRadius, equals(BorderRadius.circular(16)));
      expect(decoration.color, equals(Colors.white));
      expect(decoration.boxShadow, isNotEmpty);
    });

    testWidgets('should display address badge with correct styling', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddressCardWidget(number: 1, address: testAddress),
          ),
        ),
      );

      final badgeContainer = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(Container),
              matching: find.byType(Container),
            )
            .first,
      );

      final decoration = badgeContainer.decoration as BoxDecoration;
      expect(decoration.borderRadius, equals(BorderRadius.circular(12)));
    });

    testWidgets('should handle different address numbers', (tester) async {
      for (int i = 1; i <= 5; i++) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AddressCardWidget(number: i, address: testAddress),
            ),
          ),
        );

        expect(find.text('Dirección $i'), findsOneWidget);
      }
    });

    testWidgets('should display all address fields', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddressCardWidget(number: 1, address: testAddress),
          ),
        ),
      );

      expect(find.text('País:'), findsOneWidget);
      expect(find.text('Departamento:'), findsOneWidget);
      expect(find.text('Municipio:'), findsOneWidget);
    });
  });
}
