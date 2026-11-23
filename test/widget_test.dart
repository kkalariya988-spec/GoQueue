import 'package:flutter_test/flutter_test.dart';
import 'package:goqueue/app/app.dart';
import 'package:goqueue/features/auth/presentation/pages/login_page.dart';
import 'package:goqueue/features/splash/presentation/pages/splash_page.dart';

void main() {
  testWidgets('Splash screen shows, then signs in and enters the app', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const GoQueueApp());

    expect(find.byType(SplashPage), findsOneWidget);

    // Let the splash hold timer fire and the route transition finish.
    await tester.pump(const Duration(milliseconds: 2400));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
  });
}
