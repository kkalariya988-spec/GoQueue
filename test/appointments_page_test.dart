import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:goqueue/features/user/presentation/pages/appointments_page.dart';
import 'package:goqueue/features/user/data/mock_user_data.dart';

void main() {
  group('AppointmentsPage', () {
    testWidgets('renders the live-queue ticket with date and formatted price',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: AppointmentsPage()),
        );
        await tester.pumpAndSettle();

        expect(find.text('My Bookings & Queue'), findsOneWidget);
        expect(find.text('Manage your visits and live queue tokens'), findsOneWidget);

        // Booking details.
        expect(find.text('Glow & Glam Salon'), findsOneWidget);
        expect(find.text('Service: Classic Precision Haircut'), findsOneWidget);
        expect(find.text('Stylist: Rahul Sharma'), findsOneWidget);
        expect(find.text('Booking ID: GQ-9021'), findsOneWidget);

        // Price is formatted with the rupee sign.
        expect(find.textContaining('\u20b9299'), findsOneWidget);

        // Queue token metadata.
        expect(find.text('Position: #2'), findsOneWidget);
        expect(find.text('Est. wait: ~16 min'), findsOneWidget);

        // Live-queue badge and token.
        expect(find.text('LIVE QUEUE TOKEN'), findsOneWidget);
        expect(find.text('Q-08'), findsOneWidget);

        // New "When" row (date), previously missing from the ticket.
        expect(find.text('When'), findsOneWidget);
      });

    testWidgets('renders the empty state when bookings are cleared',
      (WidgetTester tester) async {
        // Clear the shared demo bookings list before pumping.
        MockUserData.activeBookings.clear();
        await tester.pumpWidget(
          const MaterialApp(home: AppointmentsPage()),
        );
        await tester.pumpAndSettle();

        expect(find.text('No active bookings or queue tokens'), findsOneWidget);
        expect(find.text('Explore Salons'), findsOneWidget);
      });
  });
}
