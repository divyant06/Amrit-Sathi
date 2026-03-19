// Travel Resume — smoke test
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_amrrit_sarovar/main.dart';

void main() {
  testWidgets('Profile screen renders smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TravelResumeApp());
    await tester.pumpAndSettle();

    // Verify key profile content is present
    expect(find.text('Alex Explorer'), findsOneWidget);
    expect(find.text('My Trophies'), findsOneWidget);
    expect(find.text('Saved Places'), findsOneWidget);
  });
}
