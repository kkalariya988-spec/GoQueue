import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:goqueue/core/widgets/section_header.dart';
import 'package:goqueue/features/user/presentation/pages/services_list_page.dart';

void main() {
  group('ServicesListPage', () {
    testWidgets('renders the category chips and every service row', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: ServicesListPage()));

      expect(find.text('Services'), findsOneWidget);
      expect(find.text('Beauty & Care Services'), findsOneWidget);
      expect(find.text('All Services'), findsOneWidget);

      for (final category in [
        'All',
        'Haircut',
        'Hair Styling',
        'Hair Coloring',
        'Makeup',
      ]) {
        expect(
          find.descendant(
            of: find.byKey(const Key('service_category_chips')),
            matching: find.text(category),
          ),
          findsOneWidget,
        );
      }

      // One row per catalog entry, identified by its duration.
      expect(find.text('30 mins'), findsOneWidget);
      expect(find.text('60 mins'), findsOneWidget);
      expect(find.text('90 mins'), findsOneWidget);
      expect(find.text('45 mins'), findsOneWidget);
      expect(find.text('₹1,299'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('category chips filter the list', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ServicesListPage()));

      Future<void> tapCategory(String label) async {
        await tester.tap(
          find.descendant(
            of: find.byKey(const Key('service_category_chips')),
            matching: find.text(label),
          ),
        );
        await tester.pumpAndSettle();
      }

      await tapCategory('Haircut');
      expect(find.text('30 mins'), findsOneWidget);
      expect(find.text('60 mins'), findsNothing);
      expect(find.text('90 mins'), findsNothing);
      expect(find.text('45 mins'), findsNothing);
      expect(
        find.descendant(
          of: find.byType(SectionHeader),
          matching: find.text('Haircut'),
        ),
        findsOneWidget,
      );

      await tapCategory('Makeup');
      expect(find.text('45 mins'), findsOneWidget);
      expect(find.text('30 mins'), findsNothing);

      await tapCategory('All');
      expect(find.text('30 mins'), findsOneWidget);
      expect(find.text('60 mins'), findsOneWidget);
      expect(find.text('90 mins'), findsOneWidget);
      expect(find.text('45 mins'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('lays out on a narrow phone without overflow', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: ServicesListPage()));

      expect(find.text('Services'), findsOneWidget);
      expect(find.text('All Services'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
