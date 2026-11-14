import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:goqueue/features/user/presentation/pages/salons_list_page.dart';
import 'package:goqueue/features/user/presentation/widgets/salon_card.dart';

void main() {
  group('SalonsListPage', () {
    testWidgets('renders the salon list, header and bottom nav', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SalonsListPage(),
        ),
      );

      expect(find.text('Salons'), findsOneWidget);
      expect(find.text('Top Salons Near You'), findsOneWidget);

      // Populated salon cards from mock data.
      expect(find.text('Glow & Glam Salon'), findsOneWidget);
      expect(find.text('Style Studio'), findsOneWidget);
      expect(find.text('Luxe Salon & Spa'), findsOneWidget);

      // Salon card book actions.
      expect(find.text('View salon'), findsNWidgets(3));
      expect(find.text('Book Now'), findsNWidgets(3));
    });

    testWidgets('renders a vertically scrolling list on a phone viewport', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: SalonsListPage(),
        ),
      );

      expect(find.text('Salons'), findsOneWidget);
      expect(find.text('Top Salons Near You'), findsOneWidget);
      expect(find.text('Glow & Glam Salon'), findsOneWidget);
      expect(find.text('View salon'), findsNWidgets(3));
      expect(find.text('Book Now'), findsNWidgets(3));

      // The list scrolls vertically: dragging up moves the first card.
      final topBefore = tester.getTopLeft(find.text('Glow & Glam Salon')).dy;
      await tester.drag(find.text('Glow & Glam Salon'), const Offset(0, -500));
      await tester.pumpAndSettle();
      expect(
        tester.getTopLeft(find.text('Glow & Glam Salon')).dy,
        lessThan(topBefore),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('aligns the header and the list with the dashboard inset', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: SalonsListPage(),
        ),
      );

      // 360dp wide, where the dashboard insets its header by 20dp.
      const dashboardInset = 20.0;
      expect(
        tester.getTopLeft(find.byIcon(Icons.content_cut_rounded)).dx,
        dashboardInset,
      );
      expect(
        tester.getTopLeft(find.text('Top Salons Near You')).dx,
        dashboardInset,
      );
      expect(
        tester.getTopLeft(find.byType(SalonCard).first).dx,
        dashboardInset,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('keeps the header clear of the status bar inset', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 3.0;
      tester.view.padding = const FakeViewPadding(top: 72, bottom: 36);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPadding);

      await tester.pumpWidget(
        const MaterialApp(
          home: SalonsListPage(),
        ),
      );

      // 72 physical pixels at 3x == 24 logical pixels of status bar inset.
      expect(
        tester.getTopLeft(find.text('Salons')).dy,
        greaterThanOrEqualTo(24),
      );
      expect(tester.takeException(), isNull);
    });
  });
}
