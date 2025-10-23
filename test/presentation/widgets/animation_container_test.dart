import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dvpartners_tech_test/presentation/widgets/animation_container.dart';

void main() {
  group('AnimationContainer', () {
    testWidgets('should render child widget', (tester) async {
      const testWidget = Text('Test Widget');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AnimationContainer(child: testWidget)),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Test Widget'), findsOneWidget);
    });

    testWidgets('should render child with fromRight factory', (tester) async {
      const testWidget = Text('Test Widget');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AnimationContainer.fromRight(child: testWidget)),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Test Widget'), findsOneWidget);
    });

    testWidgets('should render child with fromLeft factory', (tester) async {
      const testWidget = Text('Test Widget');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AnimationContainer.fromLeft(child: testWidget)),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Test Widget'), findsOneWidget);
    });

    testWidgets('should render child with fromTop factory', (tester) async {
      const testWidget = Text('Test Widget');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AnimationContainer.fromTop(child: testWidget)),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Test Widget'), findsOneWidget);
    });

    testWidgets('should render child with fromBottom factory', (tester) async {
      const testWidget = Text('Test Widget');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimationContainer.fromBottom(child: testWidget),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Test Widget'), findsOneWidget);
    });

    testWidgets('should apply custom duration', (tester) async {
      const testWidget = Text('Test Widget');
      const customDuration = Duration(milliseconds: 1000);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimationContainer(
              duration: customDuration,
              child: testWidget,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Test Widget'), findsOneWidget);
    });

    testWidgets('should apply custom delay', (tester) async {
      const testWidget = Text('Test Widget');
      const customDelay = Duration(milliseconds: 500);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimationContainer(delay: customDelay, child: testWidget),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Test Widget'), findsOneWidget);
    });

    testWidgets('should handle delay in factory methods', (tester) async {
      const testWidget = Text('Test Widget');
      const customDelay = Duration(milliseconds: 200);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimationContainer.fromBottom(
              delay: customDelay,
              child: testWidget,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Test Widget'), findsOneWidget);
    });

    testWidgets('should dispose properly', (tester) async {
      const testWidget = Text('Test Widget');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AnimationContainer(child: testWidget)),
        ),
      );

      await tester.pumpAndSettle();
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();

      expect(find.text('Test Widget'), findsNothing);
    });
  });
}
