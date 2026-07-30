import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:officehub/core/widgets/app_back_button.dart';
import 'package:officehub/features/visitors/presentation/register_visitor_screen.dart';

/// Verifies the Register Visit flow is a genuine two-step flow (matching the
/// Figma "visit1"/"visit2" frames): Step 1 only collects visitor
/// information, Step 2 only collects visit details, and Step 1 data
/// survives navigating back from Step 2.
void main() {
  testWidgets('Step 1 collects only visitor information fields', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterVisitorScreen()));

    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Phone number'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Company'), findsOneWidget);
    expect(find.text('Visit date'), findsNothing);
    expect(find.text('Step 1 of 2'), findsOneWidget);

    // Continue is disabled until all Step 1 fields are filled.
    final continueButton = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Continue'),
    );
    expect(continueButton.onPressed, isNull);
  });

  testWidgets('Continue navigates to Step 2, and Back preserves Step 1 data', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterVisitorScreen()));

    await tester.enterText(
      find.widgetWithText(TextField, 'e.g. Sarah Ahmed'),
      'Sarah Ahmed',
    );
    await tester.enterText(
      find.widgetWithText(TextField, '+966 55 000 0000'),
      '+966501234567',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'name@company.com'),
      'sarah@officehub.com',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Company name'),
      'OfficeHub',
    );
    await tester.pump();

    final continueFinder = find.widgetWithText(ElevatedButton, 'Continue');
    await tester.ensureVisible(continueFinder);
    await tester.tap(continueFinder);
    await tester.pumpAndSettle();

    // Now on Step 2: visit-details fields, no visitor-information fields.
    expect(find.text('Step 2 of 2'), findsOneWidget);
    expect(find.text('Visit date'), findsOneWidget);
    expect(find.text('Arrival time'), findsOneWidget);
    expect(find.text('Visit purpose'), findsOneWidget);
    expect(find.text('Meeting location'), findsOneWidget);
    expect(find.text('Name'), findsNothing);

    // Tapping Review visit before Step 2 is complete shows a validation
    // error and does not navigate away.
    final reviewFinder = find.widgetWithText(ElevatedButton, 'Review visit');
    await tester.ensureVisible(reviewFinder);
    await tester.tap(reviewFinder);
    await tester.pump();
    expect(find.text('Please complete all required fields.'), findsOneWidget);
    expect(find.text('Step 2 of 2'), findsOneWidget);

    // Back returns to Step 1 with the previously entered data intact.
    await tester.tap(find.byType(AppBackButton));
    await tester.pumpAndSettle();

    expect(find.text('Step 1 of 2'), findsOneWidget);
    expect(find.text('Sarah Ahmed'), findsOneWidget);
    expect(find.text('sarah@officehub.com'), findsOneWidget);
    expect(find.text('OfficeHub'), findsOneWidget);
  });
}
