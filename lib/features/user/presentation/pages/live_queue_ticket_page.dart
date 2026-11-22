import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../data/mock_user_data.dart';

/// Live queue ticket screen showing the user's position, estimated wait,
/// and a QR code for arrival verification at the salon.
class LiveQueueTicketPage extends StatefulWidget {
  const LiveQueueTicketPage({super.key, this.salon});

  final dynamic salon;

  @override
  State<LiveQueueTicketPage> createState() => _LiveQueueTicketPageState();
}

class _LiveQueueTicketPageState extends State<LiveQueueTicketPage> {
  String _queueToken = 'Q-08';
  int _queuePosition = 2;
  int _estimatedWaitMinutes = 15;
  DateTime _alertTime = DateTime.now().add(const Duration(seconds: 45));

  @override
  void initState() {
    super.initState();
    _generateTicket();
  }

  void _generateTicket() {
    _queueToken = 'Q-${(MockUserData.activeBookings.length + 9).toString().padLeft(2, '0')}';
    _queuePosition = MockUserData.activeBookings.length + 9;
    _estimatedWaitMinutes = _queuePosition * 8;
    _alertTime = DateTime.now().add(Duration(seconds: 45));
  }

  void _refreshTicket() {
    setState(() {
      _generateTicket();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Live Queue Ticket',
      subtitle: widget.salon != null ? 'For ${widget.salon}' : 'Enter your ticket number',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TicketHeader(
              token: _queueToken,
              position: _queuePosition,
              estimatedWait: _estimatedWaitMinutes,
            ),
            const SizedBox(height: AppSpacing.md),
            _QRCodeSection(token: _queueToken),
            const SizedBox(height: AppSpacing.md),
            _TokenDetailsSection(
              token: _queueToken,
              position: _queuePosition,
              estimatedWait: _estimatedWaitMinutes,
            ),
            const SizedBox(height: AppSpacing.md),
            _AlertSection(
              alertTime: _alertTime,
              token: _queueToken,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              text: 'Refresh Ticket',
              onPressed: _refreshTicket,
              height: 52,
            ),
            const SizedBox(height: 8),
            AppButton(
              text: 'Done',
              onPressed: () => Navigator.of(context).pop(),
              height: 52,
              isOutlined: true,
            ),
          ],
        ),
      ),
    );
  }
}

/// Header showing the queue token and position.
class _TicketHeader extends StatelessWidget {
  const _TicketHeader({
    required this.token,
    required this.position,
    required this.estimatedWait,
  });

  final String token;
  final int position;
  final int estimatedWait;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: AppRadius.borderMd,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LIVE QUEUE TICKET',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    token,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    'Position: #$position',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppRadius.borderMd,
                  ),
                  child: Text(
                    'Est. wait: ~$estimatedWait min',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// QR code for arrival verification.
class _QRCodeSection extends StatelessWidget {
  const _QRCodeSection({required this.token});

  final String token;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          Center(
            child: QrImageView(
              data: 'GoQueue:$token',
              size: 200,
              backgroundColor: AppColors.background,
              version: QrVersions.auto,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Scan at salon for arrival verification',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Details about the live queue token.
class _TokenDetailsSection extends StatelessWidget {
  const _TokenDetailsSection({
    required this.token,
    required this.position,
    required this.estimatedWait,
  });

  final String token;
  final int position;
  final int estimatedWait;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.softPink,
        borderRadius: AppRadius.borderMd,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ticket Details',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _DetailRow(label: 'Queue Token', value: token),
          _DetailRow(label: 'Position', value: '#$position'),
          _DetailRow(label: 'Est. Wait', value: '~$estimatedWait min'),
          _DetailRow(label: 'Status', value: 'In Queue'),
        ],
      ),
    );
  }
}

/// A single label-value detail row.
class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

/// Alert section showing the turn notification time.
class _AlertSection extends StatelessWidget {
  const _AlertSection({required this.alertTime, required this.token});

  final DateTime alertTime;
  final String token;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          QrImageView(
            data: 'GoQueue:$token',
            size: 200,
            backgroundColor: AppColors.background,
            version: QrVersions.auto,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Turn Alert',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Your turn will be around ${_formatHHmm(alertTime)}',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatHHmm(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
