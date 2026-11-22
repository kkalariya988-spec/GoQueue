import 'package:flutter/material.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../data/mock_user_data.dart';

/// Appointments & Active Queue tracking screen for customers.
class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key, this.onExploreSalons});

  final VoidCallback? onExploreSalons;

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  @override
  Widget build(BuildContext context) {
    final bookings = MockUserData.activeBookings;

    return AppScaffold(
      title: 'My Bookings & Queue',
      subtitle: 'Manage your visits and live queue tokens',
      body: bookings.isEmpty
          ? _emptyBookings()
          : ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: bookings.length,
                separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final item = bookings[index];
                  return _BookingTicketCard(
                    item: item,
                    onCancel: () {
                      setState(() {
                        MockUserData.activeBookings.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Appointment / Queue cancelled for ${item.salonName}.',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }

  /// Renders the "no active bookings" placeholder, mirroring the card
  /// rhythm of the rest of the screen and linking back to browsing.
  Widget _emptyBookings() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: AppColors.softPink.withValues(alpha: 0.45),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.softPink.withValues(alpha: 0.5)),
              ),
              child: Icon(Icons.calendar_today_outlined, color: AppColors.primary, size: 34),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No active bookings or queue tokens',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 15, fontWeight: FontWeight.w700, height: 1.4),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'We\'ll alert you as soon as your stylist is ready, or browse salons to book a new appointment.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              text: 'Explore Salons',
              onPressed: () {
                if (widget.onExploreSalons != null) {
                  widget.onExploreSalons!();
                } else if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushNamed(context, RouteNames.userSalons);
                }
              },
              width: 200,
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingTicketCard extends StatelessWidget {
  const _BookingTicketCard({required this.item, required this.onCancel});

  final BookingItem item;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppRadius.borderLg,
        border: Border.all(
          color: item.isLiveQueue
              ? AppColors.primary.withValues(alpha: 0.4)
              : AppColors.border,
          width: item.isLiveQueue ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header ribbon
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: item.isLiveQueue
                  ? AppColors.primary.withValues(alpha: 0.08)
                  : const Color(0xFFF9F9FB),
              borderRadius: AppRadius.borderLg,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      item.isLiveQueue ? Icons.flash_on_rounded : Icons.calendar_month_rounded,
                      size: 16,
                      color: item.isLiveQueue ? AppColors.primary : AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      item.isLiveQueue ? 'LIVE QUEUE TOKEN' : 'CONFIRMED APPOINTMENT',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: item.isLiveQueue ? AppColors.primary : AppColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: item.isLiveQueue ? AppColors.primary : AppColors.success,
                    borderRadius: AppRadius.borderPill,
                  ),
                  child: Text(
                    item.status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.isLiveQueue && item.queueToken != null) ...[
                  // Prominent Token Badge
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]),
                      borderRadius: AppRadius.borderMd,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'YOUR QUEUE TOKEN',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              item.queueToken!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Position: #${item.queuePosition ?? 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Est. wait: ~${_estimatedWaitMinutes(item)} min',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                Text(
                  item.salonName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Service: ${item.serviceName}',
                  style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Stylist: ${item.stylistName}',
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'When',
                          style: TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          _formatDateTime(item.dateTime),
                          style: TextStyle(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    if (item.isLiveQueue)
                      Text(
                        'In ~${_estimatedWaitMinutes(item)} min',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                  ],
                ),
                const Divider(height: AppSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Booking ID: ${item.id}',
                      style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                    ),
                    Text(
                      formatInr(item.price),
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.primary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Footer actions
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'Cancel',
                    onPressed: onCancel,
                    width: double.infinity,
                    backgroundColor: AppColors.error,
                    isOutlined: true,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AppButton(
                    text: 'Get Directions',
                    onPressed: () => _openDirections(context, item),
                    width: double.infinity,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Approximate minutes a live-queue patron waits, derived from their
  /// position (each position adds ~8 minutes). Falls back to a fixed estimate
  /// for queue entries that don't carry a position.
  int _estimatedWaitMinutes(BookingItem item) {
    if (item.isLiveQueue && item.queuePosition != null) {
      return item.queuePosition! * 8;
    }
    return 15;
  }

  /// Human-readable absolute datetime, with today/tomorrow/yesterday prefixes.
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final months = <String>[
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    final minuteStr = minute < 10 ? '0$minute' : '$minute';

    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    if (date == today) {
      return 'Today, ${months[dateTime.month - 1]} $hour12:$minuteStr $period';
    }
    if (date == tomorrow) {
      return 'Tomorrow, ${months[dateTime.month - 1]} $hour12:$minuteStr $period';
    }
    if (date == yesterday) {
      return 'Yesterday, ${months[dateTime.month - 1]} $hour12:$minuteStr $period';
    }
    return '${months[dateTime.month - 1]} ${dateTime.day}, $hour12:$minuteStr $period';
  }

  void _openDirections(BuildContext context, BookingItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Opening ${item.salonName} in Google Maps (demo).',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
