import 'package:flutter_test/flutter_test.dart';
import 'package:officehub/app/app.dart';

void main() {
  testWidgets('app boots and shows the splash screen', (tester) async {
    await tester.pumpWidget(const OfficeHubApp());

    expect(find.text('OfficeHub'), findsOneWidget);
    expect(find.text('Your workplace, simplified'), findsOneWidget);

    // Flush the splash screen's Future.delayed timer so none is left
    // pending when the test tears down.
    await tester.pump(const Duration(milliseconds: 1300));
  });

  testWidgets('onboarding appears after the splash screen', (tester) async {
    await tester.pumpWidget(const OfficeHubApp());
    await tester.pump(const Duration(milliseconds: 1300));

    expect(find.text('Manage your office in one place'), findsOneWidget);
  });
}
