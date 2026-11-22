import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../data/mock_user_data.dart';
import '../../data/models/salon.dart';
import 'booking_summary_page.dart';

/// Interactive date picker + time slot selector + stylist picker.
///
/// Used in the customer booking checkout flow: UserHome -> SalonDetail -> SelectDateTime.
class SelectDateTimePage extends StatefulWidget {
  const SelectDateTimePage({super.key, this.salon});

  final Salon? salon;

  @override
  State<SelectDateTimePage> createState() => _SelectDateTimePageState();
}

class _SelectDateTimePageState extends State<SelectDateTimePage> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedSlot = '11:00 AM';
  Stylist? _selectedStylist;
  final List<String> _slots = [
    '09:30 AM',
    '10:30 AM',
    '11:30 AM',
    '01:00 PM',
    '02:30 PM',
    '04:00 PM',
    '05:30 PM',
  ];

  @override
  void initState() {
    super.initState();
    _selectedStylist = MockUserData.stylists.firstWhere(
      (s) => s.isAvailable,
      orElse: () => MockUserData.stylists.first,
    );
  }

  void _goToSummary() {
    if (widget.salon == null) return;
    // Pass available data to the summary screen for a true checkout flow.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingSummaryPage(
          salon: widget.salon!,
          selectedStylist: _selectedStylist!,
          selectedDate: _selectedDate,
          selectedSlot: _selectedSlot,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Select Date & Time',
      subtitle: 'Pick your slot and stylist',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DatePickerSection(
                date: _selectedDate,
                onDateSelected: (d) => setState(() => _selectedDate = d)),
            const SizedBox(height: AppSpacing.md),
            _StylistSelectorSection(
                stylist: _selectedStylist,
                onStylistSelected: (s) => setState(() => _selectedStylist = s)),
            const SizedBox(height: AppSpacing.md),
            _SlotGridSection(
                slots: _slots,
                selectedSlot: _selectedSlot,
                onSlotSelected: (s) => setState(() => _selectedSlot = s)),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              text: 'Continue to Summary',
              onPressed: _goToSummary,
              height: 52,
            ),
          ],
        ),
      ),
    );
  }
}

/// Section showing the available dates.
class _DatePickerSection extends StatelessWidget {
  const _DatePickerSection({required this.date, required this.onDateSelected});

  final DateTime date;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    final dates = <DateTime>[
      date,
      date.add(const Duration(days: 1)),
      date.add(const Duration(days: 2)),
      date.add(const Duration(days: 3)),
      date.add(const Duration(days: 7)),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: dates.map((d) {
            final isSelected = d.day == date.day;
            return GestureDetector(
              onTap: () => onDateSelected(d),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.inputBackground,
                  borderRadius: AppRadius.borderMd,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      DateFormat('EEE, d MMM').format(d),
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// Stylist selection section.
class _StylistSelectorSection extends StatelessWidget {
  const _StylistSelectorSection({required this.stylist, required this.onStylistSelected});

  final Stylist? stylist;
  final ValueChanged<Stylist> onStylistSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Stylist',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Column(
          children: MockUserData.stylists.map((s) {
            final isSelected = s.name == stylist?.name;
            return GestureDetector(
              onTap: () => onStylistSelected(s),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary.withValues(alpha: 0.06) : AppColors.background,
                  borderRadius: AppRadius.borderMd,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                      child: Text(
                        s.initial,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            s.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: isSelected ? AppColors.primary : AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            s.specialty,
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (s.isAvailable)
                      const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.success,
                        size: 18,
                      ),
                    const SizedBox(width: 6),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// Time slot grid.
class _SlotGridSection extends StatelessWidget {
  const _SlotGridSection({required this.slots, required this.selectedSlot, required this.onSlotSelected});

  final List<String> slots;
  final String selectedSlot;
  final ValueChanged<String> onSlotSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Time Slot',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.spaceBetween,
          children: slots.map((s) {
            final isSelected = s == selectedSlot;
            return GestureDetector(
              onTap: () => onSlotSelected(s),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.inputBackground,
                  borderRadius: AppRadius.borderMd,
                ),
                child: Text(
                  s,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
