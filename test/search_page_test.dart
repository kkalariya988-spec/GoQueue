import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:goqueue/app/router/app_router.dart';
import 'package:goqueue/app/theme/app_theme.dart';
import 'package:goqueue/core/services/navigation_service.dart';
import 'package:goqueue/features/auth/data/auth_service.dart';
import 'package:goqueue/features/user/presentation/pages/search_page.dart';
import 'package:goqueue/features/user/presentation/pages/user_home_page.dart';

Future<void> _pumpSearch(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(const MaterialApp(home: SearchPage()));
  await tester.pumpAndSettle();
}

void main() {
  group('SearchPage', () {
    testWidgets('renders the search field and every section', (tester) async {
      await _pumpSearch(tester, const Size(392, 873));

      expect(find.text('Search Salon'), findsOneWidget);
      expect(find.text('Recent Searches'), findsOneWidget);
      expect(find.text('Clear All'), findsOneWidget);
      expect(find.text('Popular Searches'), findsOneWidget);
      expect(find.text('Search Suggestions'), findsOneWidget);

      for (final label in ['Glow Studio', 'Style Lounge', 'Hair & Beauty']) {
        expect(find.text(label), findsOneWidget);
      }
      for (final label in [
        'Haircut',
        'Hair Spa',
        'Facial',
        'Nails',
        'Makeup',
        'Manicure',
      ]) {
        expect(find.text(label), findsOneWidget);
      }
      for (final label in [
        'Best salons near me',
        'Hair color',
        'Bridal makeup',
        "Men's grooming",
        'Spa and massage',
      ]) {
        expect(find.text(label), findsOneWidget);
      }
      expect(tester.takeException(), isNull);
    });

    testWidgets('picking a suggestion fills the query field', (tester) async {
      await _pumpSearch(tester, const Size(392, 873));

      await tester.tap(find.text('Bridal makeup'));
      await tester.pump();

      expect(find.widgetWithText(TextField, 'Bridal makeup'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('clear all empties the recent searches', (tester) async {
      await _pumpSearch(tester, const Size(392, 873));

      await tester.tap(find.text('Clear All'));
      await tester.pumpAndSettle();

      expect(find.text('Recent Searches'), findsNothing);
      expect(find.text('Glow Studio'), findsNothing);
      expect(find.text('Hair & Beauty'), findsNothing);
      expect(find.text('Popular Searches'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('lays out on a narrow phone without overflow', (tester) async {
      await _pumpSearch(tester, const Size(320, 640));

      expect(find.text('Search Salon'), findsOneWidget);
      expect(find.text('Search Suggestions'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('search entry point', () {
    testWidgets('the dashboard search field opens the search screen', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(784, 1746);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      AuthService.instance.logout();
      await AuthService.instance.login(
        name: AuthService.demoName,
        email: AuthService.demoEmail,
        password: AuthService.demoPassword,
        delay: Duration.zero,
      );

      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          navigatorKey: NavigationService.navigatorKey,
          onGenerateRoute: AppRouter.generateRoute,
          home: const UserHomePage(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(TextField).first);
      await tester.pumpAndSettle();

      expect(find.byType(SearchPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
