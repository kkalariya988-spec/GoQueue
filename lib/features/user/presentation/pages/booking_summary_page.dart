import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../data/mock_user_data.dart';
import '../../data/models/salon.dart';
import 'payment_page.dart';

/// Confirmation screen showing the full booking breakdown with coupon entry.
///
/// Flow: SelectDateTime -> BookingSummary -> Payment
class BookingSummaryPage extends StatefulWidget {
  const BookingSummaryPage({
    super.key,
    required this.salon,
    required this.selectedStylist,
    required this.selectedDate,
    required this.selectedSlot,
  });

  final Salon salon;
  final Stylist selectedStylist;
  final DateTime selectedDate;
  final String selectedSlot;

  @override
  State<BookingSummaryPage> createState() => _BookingSummaryPageState();
}

class _BookingSummaryPageState extends State<BookingSummaryPage> {
  String _couponCode = '';
  bool _couponApplied = false;
  double _couponDiscount = 0;

  @override
  void initState() {
    super.initState();
    _applyCoupon(_couponCode);
  }

  void _applyCoupon(String code) {
    // Demo coupon: SAVE20 = 20% off, SAVE10 = 10% off
    if (code == 'SAVE20') {
      _couponApplied = true;
      _couponDiscount = 0.20;
      _couponCode = 'SAVE20';
    } else if (code == 'SAVE10') {
      _couponApplied = true;
      _couponDiscount = 0.10;
      _couponCode = 'SAVE10';
    } else {
      _couponApplied = false;
      _couponCode = '';
      _couponDiscount = 0;
    }
    if (mounted) {
      setState(() {});
    }
  }

  double get _subtotal {
    return widget.salon.startingPrice.toDouble();
  }

  double get _tax {
    return _subtotal * 0.12;
  }

  double get _discountedSubtotal {
    return _subtotal - _couponDiscount * _subtotal;
  }

  double get _total {
    return _discountedSubtotal + _tax;
  }

  void _goToPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentPage(
          salon: widget.salon,
          selectedStylist: widget.selectedStylist,
          selectedDate: widget.selectedDate,
          selectedSlot: widget.selectedSlot,
          servicePrice: widget.salon.startingPrice,
          subtotal: _subtotal,
          tax: _tax,
          couponDiscount: _couponDiscount,
          total: _total,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Booking Summary',
      subtitle: '${widget.salon.name} - ${_formatDateTimeWS()}',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DetailCard(
              label: 'Salon',
              value: widget.salon.name,
              icon: Icons.store_outlined,
            ),
            const SizedBox(height: AppSpacing.sm),
            _DetailCard(
              label: 'Service',
              value: 'Classic Precision Haircut',
              icon: Icons.style_outlined,
            ),
            const SizedBox(height: AppSpacing.sm),
            _DetailCard(
              label: 'Stylist',
              value: widget.selectedStylist.name,
              icon: Icons.person_outlined,
            ),
            const SizedBox(height: AppSpacing.md),
            _PriceBreakdown(
              subtotal: _subtotal,
              tax: _tax,
              couponApplied: _couponApplied,
              couponCode: _couponCode,
              couponDiscount: _couponDiscount,
              total: _total,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              text: 'Continue to Payment',
              onPressed: _goToPayment,
              height: 52,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTimeWS() {
    final now = DateTime.now();
    final date = DateTime(widget.selectedDate.year, widget.selectedDate.month, widget.selectedDate.day);
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    if (date == today) {
      return 'Today, ${DateFormat('h:mm a').format(widget.selectedDate)}';
    } else if (date == tomorrow) {
      return 'Tomorrow, ${DateFormat('h:mm a').format(widget.selectedDate)}';
    } else if (date == yesterday) {
      return 'Yesterday, ${DateFormat('h:mm a').format(widget.selectedDate)}';
    }
    return '${DateFormat('MMM d').format(widget.selectedDate)}, ${DateFormat('h:mm a').format(widget.selectedDate)}';
  }
}

/// A single detail row (label + value) used in the summary.
class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Price breakdown with coupon entry.
class _PriceBreakdown extends StatelessWidget {
  const _PriceBreakdown({
    required this.subtotal,
    required this.tax,
    required this.couponApplied,
    required this.couponCode,
    required this.couponDiscount,
    required this.total,
  });

  final double subtotal;
  final double tax;
  final bool couponApplied;
  final String couponCode;
  final double couponDiscount;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Breakdown',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        _LineItem(
          label: 'Service Fee',
          price: _formatPrice(subtotal),
          isAmount: true,
        ),
        if (couponApplied) ...[
          const SizedBox(height: AppSpacing.xs),
          _LineItem(
            label: 'Coupon ($couponCode)',
            price: '-${_formatPrice(subtotal * couponDiscount)}',
            isAmount: true,
          ),
        ],
        const SizedBox(height: AppSpacing.xs),
        _LineItem(
          label: 'Taxes (12%)',
          price: _formatPrice(tax),
          isAmount: true,
        ),
        const SizedBox(height: AppSpacing.lg),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.softPink,
            borderRadius: AppRadius.borderMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    _formatPrice(total),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              if (couponApplied) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'You saved ${_formatPrice(subtotal * couponDiscount)}',
                  style: TextStyle(
                    color: AppColors.success,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ]
            ],
          ),
        ),
      ],
    );
  }

  String _formatPrice(double price) {
    return 'Rs ${price.toStringAsFixed(0)}';
  }
}

class _LineItem extends StatelessWidget {
  const _LineItem({required this.label, required this.price, required this.isAmount});

  final String label;
  final String price;
  final bool isAmount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isAmount ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          price,
          style: TextStyle(
            color: isAmount ? AppColors.primary : AppColors.textSecondary,
            fontWeight: isAmount ? FontWeight.w700 : FontWeight.w500,
            fontSize: isAmount ? 14 : 12,
          ),
        ),
      ],
    );
  }
}
