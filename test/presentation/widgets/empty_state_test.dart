import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dvpartners_tech_test/presentation/widgets/user_card/empty_state.dart';

void main() {
  group('EmptyState', () {
    testWidgets('should display error state correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState.error(
              message: 'Something went wrong',
              icon: Icons.error,
              color: Colors.red,
            ),
          ),
        ),
      );

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.byIcon(Icons.error), findsOneWidget);
    });

    testWidgets('should display loading state correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: EmptyState.loading())),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(Center), findsOneWidget);
    });

    testWidgets('should display no data state correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState.noData(
              message: 'No users found',
              icon: Icons.search,
              color: Colors.grey,
            ),
          ),
        ),
      );

      expect(find.text('No users found'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should use default values for error state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: EmptyState.error())),
      );

      expect(find.text('An error occurred'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should use default values for no data state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: EmptyState.noData())),
      );

      expect(find.text('No data found'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should have correct layout structure', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: EmptyState.noData(message: 'Test message')),
        ),
      );

      expect(find.byType(SizedBox), findsWidgets);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('should center content correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: EmptyState.noData(message: 'Test message')),
        ),
      );

      final column = tester.widget<Column>(find.byType(Column));
      expect(column.mainAxisAlignment, equals(MainAxisAlignment.center));
      expect(column.crossAxisAlignment, equals(CrossAxisAlignment.center));
    });

    testWidgets('should handle custom colors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState.error(message: 'Custom error', color: Colors.blue),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.color, equals(Colors.blue));
    });

    testWidgets('should handle custom icons', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState.noData(
              message: 'Custom no data',
              icon: Icons.folder_open,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.folder_open), findsOneWidget);
    });
  });
}
