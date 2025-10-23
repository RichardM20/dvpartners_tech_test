import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dvpartners_tech_test/presentation/widgets/buttons/button.dart';

void main() {
  group('Button', () {
    testWidgets('should render icon button correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Button.icon(icon: Icons.add, onTap: () {}),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('should render loading button correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Button.loading(
              initialText: 'Save',
              primaryText: 'Saving...',
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.text('Saving...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should render normal button correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Button.loading(
              initialText: 'Save',
              primaryText: 'Saving...',
              isLoading: false,
            ),
          ),
        ),
      );

      expect(find.text('Save'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should handle tap when not loading', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Button.loading(
              initialText: 'Save',
              primaryText: 'Saving...',
              isLoading: false,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      expect(tapped, isTrue);
    });

    testWidgets('should not handle tap when loading', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Button.loading(
              initialText: 'Save',
              primaryText: 'Saving...',
              isLoading: true,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      expect(tapped, isFalse);
    });

    testWidgets('should apply custom background color', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Button.loading(
              initialText: 'Save',
              primaryText: 'Saving...',
              isLoading: false,
              backgroundColor: Colors.red,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, equals(Colors.red));
    });

    testWidgets('should have correct dimensions for icon button', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Button.icon(icon: Icons.add, onTap: () {}),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.constraints?.maxHeight, equals(35));
    });

    testWidgets('should have correct dimensions for text button', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Button.loading(
              initialText: 'Save',
              primaryText: 'Saving...',
              isLoading: false,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.constraints?.maxHeight, equals(45));
    });
  });
}
