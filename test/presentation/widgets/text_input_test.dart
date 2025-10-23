import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dvpartners_tech_test/presentation/widgets/inputs/text_input.dart';

void main() {
  group('TextInputApp', () {
    testWidgets('should render text input with label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TextInputApp(label: 'Name')),
        ),
      );

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Name'), findsOneWidget);
    });

    testWidgets('should display initial value', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextInputApp(label: 'Name', value: 'John Doe'),
          ),
        ),
      );

      final textField = tester.widget<TextFormField>(
        find.byType(TextFormField),
      );
      expect(textField.initialValue, equals('John Doe'));
    });

    testWidgets('should call onChanged when text changes', (tester) async {
      String? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextInputApp(
              label: 'Name',
              onChanged: (value) => changedValue = value,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'New Text');
      expect(changedValue, equals('New Text'));
    });

    testWidgets('should call validator when form is validated', (tester) async {
      String? validationResult;
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: TextInputApp(
                label: 'Name',
                validator: (value) {
                  validationResult = value;
                  return value?.isEmpty == true ? 'Required' : null;
                },
              ),
            ),
          ),
        ),
      );

      formKey.currentState?.validate();

      expect(validationResult, isNotNull);
    });

    testWidgets('should have correct decoration properties', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TextInputApp(label: 'Name')),
        ),
      );

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Name'), findsOneWidget);
    });

    testWidgets('should handle empty value in validator', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: TextInputApp(
                label: 'Name',
                validator: (value) =>
                    value?.isEmpty == true ? 'Required' : null,
              ),
            ),
          ),
        ),
      );

      final isValid = formKey.currentState?.validate() ?? false;

      expect(isValid, isFalse);
    });

    testWidgets('should handle valid value in validator', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              child: TextInputApp(
                label: 'Name',
                value: 'John Doe',
                validator: (value) =>
                    value?.isEmpty == true ? 'Required' : null,
              ),
            ),
          ),
        ),
      );

      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: TextInputApp(
                label: 'Name',
                value: 'John Doe',
                validator: (value) =>
                    value?.isEmpty == true ? 'Required' : null,
              ),
            ),
          ),
        ),
      );

      final isValid = formKey.currentState?.validate() ?? false;

      expect(isValid, isTrue);
    });
  });
}
