import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../data/mock_user_data.dart';
import '../../data/models/salon.dart';

/// Dummy payment method selection + simulated transaction gateway.
///
/// Flow: BookingSummary -> Payment -> Appointments (success)
class PaymentPage extends StatefulWidget {
  const PaymentPage({
    super.key,
    required this.salon,
    required this.selectedStylist,
    required this.selectedDate,
    required this.selectedSlot,
    required this.servicePrice,
    required this.subtotal,
    required this.tax,
    required this.couponDiscount,
    required this.total,
  });

  final Salon salon;
  final Stylist selectedStylist;
  final DateTime selectedDate;
  final String selectedSlot;
  final int servicePrice;
  final double subtotal;
  final double tax;
  final double couponDiscount;
  final double total;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedMethod = 'Card';
  bool _isProcessing = false;

  List<Map<String, dynamic>> get _methods => [
    {'label': 'Card', 'icon': Icons.credit_card_outlined},
    {'label': 'UPI', 'icon': Icons.account_balance_outlined},
    {'label': 'Netbanking', 'icon': Icons.terminal_outlined},
    {'label': 'Pay at Salon', 'icon': Icons.payment_outlined},
  ];

  void _confirm() {
    setState(() {
      _isProcessing = true;
    });
    // Simulate network latency for a realistic payment gateway experience.
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        // Return to the appointments page with the new booking in the list.
        _completeBooking();
      }
    });
  }

  void _completeBooking() {
    final booking = BookingItem(
      id: 'GQ-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      salonName: widget.salon.name,
      serviceName: 'Classic Precision Haircut',
      stylistName: widget.selectedStylist.name,
      dateTime: DateTime(
        widget.selectedDate.year,
        widget.selectedDate.month,
        widget.selectedDate.day,
        11,
      ),
      price: widget.total.toInt(),
      isLiveQueue: false,
      status: 'Confirmed',
    );
    // Insert the new booking into the active bookings list.
    MockUserData.activeBookings.insert(0, booking);
    // Navigate back to the appointments page.
    Navigator.of(context).pushReplacementNamed('/user/appointments');
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Payment',
      subtitle: 'Select your payment method',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SummaryRow(
              label: 'Salon',
              value: widget.salon.name,
            ),
            _SummaryRow(
              label: 'Service',
              value: 'Classic Precision Haircut',
            ),
            _SummaryRow(
              label: 'Stylist',
              value: widget.selectedStylist.name,
            ),
            _SummaryRow(
              label: 'Date & Time',
              value: '${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}, ${widget.selectedSlot}',
            ),
            const SizedBox(height: AppSpacing.md),
            _SummaryRow(
              label: 'Total',
              value: '₹${widget.total.toInt()}',
              isAmount: true,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Select Payment Method',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Column(
              children: _methods.map((m) {
                final isSelected = m['label'] == _selectedMethod;
                return GestureDetector(
                  onTap: () => setState(() => _selectedMethod = m['label']),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.08)
                          : AppColors.surface,
                      borderRadius: AppRadius.borderMd,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          m['icon'] as IconData,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            m['label'] as String,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.success,
                            size: 22,
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              text: _isProcessing ? 'Processing...' : 'Confirm Payment',
              onPressed: _isProcessing ? null : _confirm,
              height: 52,
              isLoading: _isProcessing,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value, this.isAmount = false});

  final String label;
  final String value;
  final bool isAmount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: isAmount ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isAmount ? AppColors.primary : AppColors.textSecondary,
              fontWeight: isAmount ? FontWeight.w700 : FontWeight.w500,
              fontSize: isAmount ? 14 : 12,
            ),
          ),
        ],
      ),
    );
  }
}
