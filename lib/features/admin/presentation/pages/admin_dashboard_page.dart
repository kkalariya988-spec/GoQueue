import 'package:flutter/material.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../auth/data/auth_service.dart';
import '../../data/admin_repository.dart';
import '../../data/models/admin_models.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _selectedNavIndex = 0; // 0: Overview, 1: Salons, 2: Users, 3: Campaigns, 4: Settlements
  final _adminRepo = AdminRepository.instance;

  void _handleLogout() {
    AuthService.instance.logout();
    NavigationService.pushNamedAndRemoveUntil(
      RouteNames.login,
      (route) => false,
    );
  }

  void _showAddCampaignDialog() {
    final codeCtrl = TextEditingController();
    final titleCtrl = TextEditingController();
    final discountCtrl = TextEditingController(text: '15');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
        title: const Text('Create Global Promo Campaign', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: codeCtrl,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(labelText: 'Promo Code (e.g. FLASH25)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Campaign Description'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: discountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Discount % (e.g. 25)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (codeCtrl.text.trim().isEmpty || titleCtrl.text.trim().isEmpty) return;
              setState(() {
                _adminRepo.addCampaign(
                  code: codeCtrl.text.trim(),
                  title: titleCtrl.text.trim(),
                  discount: int.tryParse(discountCtrl.text.trim()) ?? 10,
                );
              });
              Navigator.pop(ctx);
            },
            child: const Text('Publish Campaign'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.shield_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GoQueue Super Admin',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Global Platform Operations',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.textSecondary),
            tooltip: 'Logout',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: Row(
        children: [
          if (isDesktop)
            NavigationRail(
              selectedIndex: _selectedNavIndex,
              onDestinationSelected: (idx) => setState(() => _selectedNavIndex = idx),
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard_rounded),
                  label: Text('Overview'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.storefront_outlined),
                  selectedIcon: Icon(Icons.storefront_rounded),
                  label: Text('Salons'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.people_outline_rounded),
                  selectedIcon: Icon(Icons.people_rounded),
                  label: Text('Users'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.campaign_outlined),
                  selectedIcon: Icon(Icons.campaign_rounded),
                  label: Text('Campaigns'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.payments_outlined),
                  selectedIcon: Icon(Icons.payments_rounded),
                  label: Text('Settlements'),
                ),
              ],
            ),
          Expanded(
            child: IndexedStack(
              index: _selectedNavIndex,
              children: [
                _buildOverviewTab(),
                _buildSalonsTab(),
                _buildUsersTab(),
                _buildCampaignsTab(),
                _buildSettlementsTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: isDesktop
          ? null
          : NavigationBar(
              selectedIndex: _selectedNavIndex,
              onDestinationSelected: (idx) => setState(() => _selectedNavIndex = idx),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  label: 'Overview',
                ),
                NavigationDestination(
                  icon: Icon(Icons.storefront_outlined),
                  label: 'Salons',
                ),
                NavigationDestination(
                  icon: Icon(Icons.people_outline_rounded),
                  label: 'Users',
                ),
                NavigationDestination(
                  icon: Icon(Icons.campaign_outlined),
                  label: 'Offers',
                ),
                NavigationDestination(
                  icon: Icon(Icons.payments_outlined),
                  label: 'Payouts',
                ),
              ],
            ),
    );
  }

  Widget _buildOverviewTab() {
    final salons = _adminRepo.salons;
    final approvedSalons = salons.where((s) => s.status == SalonApprovalStatus.approved).length;
    final pendingSalons = salons.where((s) => s.status == SalonApprovalStatus.pending).length;
    final users = _adminRepo.users;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Platform Overview & Performance',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (ctx, constraints) {
            final isWide = constraints.maxWidth > 650;
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _MetricCard(
                  width: isWide ? (constraints.maxWidth - 48) / 4 : (constraints.maxWidth - 16) / 2,
                  title: 'Total Salons',
                  value: '${salons.length}',
                  subText: '$approvedSalons Active • $pendingSalons Pending',
                  icon: Icons.storefront_rounded,
                  color: Colors.indigo,
                ),
                _MetricCard(
                  width: isWide ? (constraints.maxWidth - 48) / 4 : (constraints.maxWidth - 16) / 2,
                  title: 'Total Users',
                  value: '${users.length * 314}',
                  subText: 'Across 14 cities',
                  icon: Icons.people_rounded,
                  color: Colors.blueAccent,
                ),
                _MetricCard(
                  width: isWide ? (constraints.maxWidth - 48) / 4 : (constraints.maxWidth - 16) / 2,
                  title: 'Monthly Volume',
                  value: '\$48,920',
                  subText: '+24% from last month',
                  icon: Icons.trending_up_rounded,
                  color: Colors.green,
                ),
                _MetricCard(
                  width: isWide ? (constraints.maxWidth - 48) / 4 : (constraints.maxWidth - 16) / 2,
                  title: 'Net Platform Cut',
                  value: '\$5,870',
                  subText: 'Avg 12.5% take rate',
                  icon: Icons.account_balance_wallet_rounded,
                  color: AppColors.primary,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 28),

        // Urgent Action: Pending approvals
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Pending Salon Applications',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            TextButton(
              onPressed: () => setState(() => _selectedNavIndex = 1),
              child: const Text('View All Salons'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...salons
            .where((s) => s.status == SalonApprovalStatus.pending)
            .map((s) => _PendingSalonCard(
                  salon: s,
                  onApprove: () {
                    setState(() {
                      _adminRepo.updateSalonStatus(s.id, SalonApprovalStatus.approved);
                    });
                  },
                  onReject: () {
                    setState(() {
                      _adminRepo.updateSalonStatus(s.id, SalonApprovalStatus.rejected);
                    });
                  },
                )),
      ],
    );
  }

  Widget _buildSalonsTab() {
    final salons = _adminRepo.salons;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Salon Directory & Onboarding',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 16),
        ...salons.map(
          (s) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.borderLg,
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.softPink,
                  radius: 22,
                  child: Text(
                    s.name[0],
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            s.name,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          _StatusChip(status: s.status),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Owner: ${s.ownerName} (${s.ownerEmail}) • ${s.city}',
                        style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Commission: ${s.commissionRate}% • Monthly: \$${s.monthlyRevenue.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ),
                if (s.status == SalonApprovalStatus.pending)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _adminRepo.updateSalonStatus(s.id, SalonApprovalStatus.approved);
                      });
                    },
                    child: const Text('Approve'),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUsersTab() {
    final users = _adminRepo.users;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'User Management & Role Directory',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 16),
        ...users.map(
          (u) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.borderLg,
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: u.role == 'Super Admin'
                      ? Colors.deepPurple
                      : (u.role == 'Manager' ? AppColors.primary : Colors.blue),
                  child: Text(
                    u.name[0],
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            u.name,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          if (u.isBanned) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'BANNED',
                                style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${u.email} • Joined ${u.joinedDate}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    u.role,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 12),
                if (u.role != 'Super Admin')
                  IconButton(
                    icon: Icon(
                      u.isBanned ? Icons.lock_open_rounded : Icons.block_rounded,
                      color: u.isBanned ? Colors.green : Colors.red,
                    ),
                    tooltip: u.isBanned ? 'Unban User' : 'Ban User',
                    onPressed: () {
                      setState(() {
                        _adminRepo.toggleUserBan(u.id);
                      });
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCampaignsTab() {
    final campaigns = _adminRepo.campaigns;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Global Campaigns & Promo Codes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: _showAddCampaignDialog,
              icon: const Icon(Icons.add_rounded, size: 16),
              label: const Text('New Campaign'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...campaigns.map(
          (c) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.borderLg,
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.softPink,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.local_offer_rounded, color: AppColors.primary),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            c.code,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${c.discountPercent}% OFF',
                              style: const TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${c.title} • Used ${c.usageCount} times',
                        style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: c.isActive,
                  activeTrackColor: AppColors.primary,
                  onChanged: (val) {
                    setState(() {
                      _adminRepo.toggleCampaign(c.id);
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettlementsTab() {
    final payouts = _adminRepo.payouts;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Settlements & Payout Ledger',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 16),
        ...payouts.map(
          (p) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.borderLg,
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: p.status == 'Paid'
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        p.status == 'Paid' ? Icons.check_circle_rounded : Icons.pending_rounded,
                        color: p.status == 'Paid' ? Colors.green : Colors.orange,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.salonName,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Settlement Date: ${p.date}',
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  '\$${p.amount.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.width,
    required this.title,
    required this.value,
    required this.subText,
    required this.icon,
    required this.color,
  });

  final double width;
  final String title;
  final String value;
  final String subText;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.borderLg,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            subText,
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _PendingSalonCard extends StatelessWidget {
  const _PendingSalonCard({
    required this.salon,
    required this.onApprove,
    required this.onReject,
  });

  final AdminSalonModel salon;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.borderLg,
        border: Border.all(color: Colors.orange.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  salon.name,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${salon.city} • Applied: ${salon.appliedDate}',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                Text(
                  'Owner: ${salon.ownerName} (${salon.ownerEmail})',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onReject,
            child: const Text('Reject', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: onApprove,
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final SalonApprovalStatus status;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case SalonApprovalStatus.approved:
        bg = Colors.green.withValues(alpha: 0.12);
        fg = Colors.green;
        label = 'Active';
        break;
      case SalonApprovalStatus.pending:
        bg = Colors.orange.withValues(alpha: 0.12);
        fg = Colors.orange;
        label = 'Pending Review';
        break;
      case SalonApprovalStatus.rejected:
        bg = Colors.red.withValues(alpha: 0.12);
        fg = Colors.red;
        label = 'Rejected';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
      child: Text(
        label,
        style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}
