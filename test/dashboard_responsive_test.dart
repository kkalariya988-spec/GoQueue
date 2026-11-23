import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goqueue/app/theme/app_theme.dart';
import 'package:goqueue/core/widgets/app_button.dart';
import 'package:goqueue/features/auth/data/auth_service.dart';
import 'package:goqueue/features/user/presentation/pages/user_home_page.dart';

Future<void> _pumpDashboard(
  WidgetTester tester,
  Size size, {
  double textScale = 1.0,
}) async {
  tester.view.physicalSize = Size(size.width * 2, size.height * 2);
  tester.view.devicePixelRatio = 2.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      ),
      home: const UserHomePage(),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUp(() async {
    AuthService.instance.logout();
    await AuthService.instance.login(
      name: AuthService.demoName,
      email: AuthService.demoEmail,
      password: AuthService.demoPassword,
      delay: Duration.zero,
    );
  });

  testWidgets('phone dashboard renders without overflow', (tester) async {
    await _pumpDashboard(tester, const Size(402, 874));

    expect(find.text('Hi, Khushi'), findsOneWidget);
    expect(find.text('Popular Services'), findsOneWidget);
    expect(find.text('Top Salons Near You'), findsOneWidget);
    expect(find.byKey(const Key('bottom_nav_0')), findsOneWidget);
    expect(find.byKey(const Key('rail_nav_0')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('narrow phone hides artwork and still lays out', (tester) async {
    await _pumpDashboard(tester, const Size(320, 640));

    expect(find.text('Popular Services'), findsOneWidget);
    expect(find.byKey(const Key('bottom_nav_4')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tablet dashboard renders without overflow', (tester) async {
    await _pumpDashboard(tester, const Size(834, 1112));

    expect(find.text('Top Salons Near You'), findsOneWidget);
    expect(find.byKey(const Key('bottom_nav_0')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('desktop dashboard uses the navigation rail', (tester) async {
    await _pumpDashboard(tester, const Size(1440, 900));

    expect(find.byKey(const Key('rail_nav_0')), findsOneWidget);
    expect(find.byKey(const Key('bottom_nav_0')), findsNothing);
    expect(find.text('Popular Services'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('phone dashboard handles 200% text scaling', (tester) async {
    await _pumpDashboard(tester, const Size(402, 874), textScale: 2.0);

    expect(find.text('Hi, Khushi'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const Key('bottom_nav_4')));
    await tester.pumpAndSettle();
    expect(find.text(AuthService.demoEmail), findsWidgets);
    expect(find.widgetWithText(AppButton, 'Log Out'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('bottom navigation moves between dashboard tabs', (tester) async {
    await _pumpDashboard(tester, const Size(402, 874));

    await tester.tap(find.byKey(const Key('bottom_nav_1')));
    await tester.pumpAndSettle();
    expect(find.text('Start your appointment'), findsOneWidget);
    expect(find.text('Glow & Glam Salon'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const Key('bottom_nav_4')));
    await tester.pumpAndSettle();
    expect(find.text(AuthService.demoEmail), findsWidgets);
    expect(find.widgetWithText(AppButton, 'Log Out'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
