import 'package:flutter_test/flutter_test.dart';
import 'package:goqueue/app/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const GoQueueApp());
    expect(find.text('GoQueue'), findsOneWidget);
  });
}
