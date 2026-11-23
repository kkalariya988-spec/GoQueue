import 'package:flutter/material.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../auth/data/auth_service.dart';
import '../../data/manager_repository.dart';
import '../../data/models/manager_models.dart';
import 'manager_profile_page.dart';

class ManagerDashboardPage extends StatefulWidget {
  const ManagerDashboardPage({super.key});

  @override
  State<ManagerDashboardPage> createState() => _ManagerDashboardPageState();
}

class _ManagerDashboardPageState extends State<ManagerDashboardPage> {
  int _currentTab = 0; // 0: Live Queue, 1: Staff, 2: Services, 3: Analytics, 4: Profile

  final _repo = ManagerRepository.instance;

  void _handleLogout() {
    AuthService.instance.logout();
    NavigationService.pushNamedAndRemoveUntil(
      RouteNames.login,
      (route) => false,
    );
  }

  void _showTicketDetailsDialog(QueueTicket ticket) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.softPink,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                ticket.ticketNumber,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    ticket.customerName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ticket.isWalkIn ? 'Walk-in Client' : 'Online Booking',
                    style: TextStyle(
                      fontSize: 12,
                      color: ticket.isWalkIn ? Colors.blue : Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _dialogDetailRow('Current Status', ticket.status.name.toUpperCase()),
            _dialogDetailRow('Selected Service', ticket.serviceName),
            _dialogDetailRow('Assigned Stylist', ticket.stylistName),
            _dialogDetailRow('Estimated Wait', '~${ticket.estimatedWaitMinutes} minutes'),
            const SizedBox(height: 12),
            const Text(
              'Queue Note & Instructions',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              ticket.status == QueueStatus.inService
                  ? 'Customer is currently in chair receiving service from ${ticket.stylistName}.'
                  : (ticket.status == QueueStatus.waiting
                      ? 'Customer is in the waiting lounge. Click "Call to Chair" when stylist seat is sanitized and ready.'
                      : 'Service successfully finished and payment processed.'),
              style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
          if (ticket.status == QueueStatus.waiting) ...[
            TextButton(
              onPressed: () {
                setState(() {
                  _repo.updateTicketStatus(ticket.id, QueueStatus.noShow);
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${ticket.customerName} marked as No-show.')),
                );
              },
              child: const Text('Mark No-show', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _repo.updateTicketStatus(ticket.id, QueueStatus.inService);
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${ticket.customerName} called to chair!')),
                );
              },
              icon: const Icon(Icons.chair_rounded, size: 16),
              label: const Text('Call to Chair'),
            ),
          ] else if (ticket.status == QueueStatus.inService) ...[
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _repo.updateTicketStatus(ticket.id, QueueStatus.completed);
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${ticket.customerName} marked as completed!')),
                );
              },
              icon: const Icon(Icons.check_rounded, size: 16),
              label: const Text('Mark Done'),
            ),
          ],
        ],
      ),
    );
  }

  void _showStaffDetailsDialog(ManagerStaffMember staff) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.softPink,
              child: Text(
                staff.name[0],
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    staff.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    staff.role,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _dialogDetailRow('Staff ID', staff.id),
            _dialogDetailRow('Specialty / Role', staff.role),
            _dialogDetailRow('Active Status', staff.isActive ? 'Active on floor' : 'Off-duty'),
            _dialogDetailRow('Break Status', staff.isOnBreak ? 'On Break' : 'Available'),
            const SizedBox(height: 12),
            const Text(
              'Stylist Overview',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 4),
            const Text(
              'Certified stylist eligible for assignment in online appointments and walk-in queue management.',
              style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
          OutlinedButton(
            onPressed: () {
              setState(() {
                _repo.toggleStaffStatus(
                  staff.id,
                  isActive: staff.isActive,
                  isOnBreak: !staff.isOnBreak,
                );
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    staff.isOnBreak ? '${staff.name} is back from break.' : '${staff.name} is now on break.',
                  ),
                ),
              );
            },
            child: Text(staff.isOnBreak ? 'End Break' : 'Send on Break'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: staff.isActive ? Colors.red : Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _repo.toggleStaffStatus(staff.id, isActive: !staff.isActive);
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    staff.isActive ? '${staff.name} set to Off-duty.' : '${staff.name} marked Active on floor.',
                  ),
                ),
              );
            },
            child: Text(staff.isActive ? 'Clock Out' : 'Clock In / Active'),
          ),
        ],
      ),
    );
  }

  void _showServiceDetailsDialog(ManagerServiceItem service) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.softPink,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.spa_rounded, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    service.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '₹${service.price.toStringAsFixed(0)} • ${service.durationMinutes} mins',
                    style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _dialogDetailRow('Service ID', service.id),
            _dialogDetailRow('Duration', '${service.durationMinutes} minutes'),
            _dialogDetailRow('Price', '₹${service.price.toStringAsFixed(2)}'),
            _dialogDetailRow('Catalog Visibility', service.isEnabled ? 'Available for booking' : 'Disabled'),
            const SizedBox(height: 12),
            const Text(
              'Service Description',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              'Offered at Luxe Cut Studio. Includes consultation, specialized treatment, styling, and finishing touches.',
              style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: service.isEnabled ? Colors.orange : AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _repo.toggleServiceStatus(service.id, !service.isEnabled);
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    service.isEnabled ? '${service.title} disabled from catalog.' : '${service.title} enabled for booking!',
                  ),
                ),
              );
            },
            child: Text(service.isEnabled ? 'Disable Service' : 'Enable Service'),
          ),
        ],
      ),
    );
  }

  static Widget _dialogDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  void _openWalkInDialog() {
    final nameCtrl = TextEditingController();
    String selectedService = _repo.services.first.title;
    String selectedStylist = _repo.staff.first.name;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
            title: const Text(
              'Add Walk-in Customer',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Customer Name',
                      hintText: 'e.g. Liam Smith',
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: selectedService,
                    decoration: const InputDecoration(labelText: 'Service'),
                    items: _repo.services
                        .map(
                          (s) => DropdownMenuItem(
                            value: s.title,
                            child: Text(s.title),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setModalState(() => selectedService = val);
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: selectedStylist,
                    decoration: const InputDecoration(labelText: 'Stylist'),
                    items: [
                      ..._repo.staff.map(
                        (st) => DropdownMenuItem(
                          value: st.name,
                          child: Text(st.name),
                        ),
                      ),
                      const DropdownMenuItem(
                        value: 'Any Stylist',
                        child: Text('Any Available Stylist'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) setModalState(() => selectedStylist = val);
                    },
                  ),
                ],
              ),
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
                  if (nameCtrl.text.trim().isEmpty) return;
                  setState(() {
                    _repo.addWalkIn(
                      customerName: nameCtrl.text.trim(),
                      serviceName: selectedService,
                      stylistName: selectedStylist,
                    );
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Walk-in customer added to queue!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: const Text('Add to Queue'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tickets = _repo.tickets;
    final waiting = tickets.where((t) => t.status == QueueStatus.waiting).toList();
    final inService = tickets.where((t) => t.status == QueueStatus.inService).toList();
    final completed = tickets.where((t) => t.status == QueueStatus.completed).toList();

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
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Luxe Cut Studio',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Manager Control Center',
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
      body: Column(
        children: [
          // KPI Metric Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              children: [
                _KpiMetric(
                  label: 'Waiting',
                  value: '${waiting.length}',
                  color: Colors.orange,
                  icon: Icons.hourglass_top_rounded,
                ),
                _KpiMetric(
                  label: 'In Chair',
                  value: '${inService.length}',
                  color: AppColors.primary,
                  icon: Icons.chair_rounded,
                ),
                _KpiMetric(
                  label: 'Completed',
                  value: '${completed.length}',
                  color: Colors.green,
                  icon: Icons.check_circle_rounded,
                ),
                _KpiMetric(
                  label: 'Active Staff',
                  value: '${_repo.staff.where((s) => s.isActive && !s.isOnBreak).length}',
                  color: Colors.blueAccent,
                  icon: Icons.people_alt_rounded,
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),

          // Main View Tabs
          Expanded(
            child: IndexedStack(
              index: _currentTab,
              children: [
                _buildLiveQueueView(waiting, inService, completed),
                _buildStaffView(),
                _buildServicesView(),
                _buildAnalyticsView(completed),
                const ManagerProfilePage(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _currentTab == 0
          ? FloatingActionButton.extended(
              onPressed: _openWalkInDialog,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.person_add_alt_1_rounded),
              label: const Text('Add Walk-in'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTab,
        onDestinationSelected: (idx) => setState(() => _currentTab = idx),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.view_kanban_outlined),
            selectedIcon: Icon(Icons.view_kanban_rounded),
            label: 'Queue Board',
          ),
          NavigationDestination(
            icon: Icon(Icons.badge_outlined),
            selectedIcon: Icon(Icons.badge_rounded),
            label: 'Stylists',
          ),
          NavigationDestination(
            icon: Icon(Icons.spa_outlined),
            selectedIcon: Icon(Icons.spa_rounded),
            label: 'Services',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_rounded),
            selectedIcon: Icon(Icons.insights_rounded),
            label: 'Today Stats',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildLiveQueueView(
    List<QueueTicket> waiting,
    List<QueueTicket> inService,
    List<QueueTicket> completed,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // In Service Section
        _SectionHeader(
          title: 'Currently in Chair (${inService.length})',
          color: AppColors.primary,
        ),
        const SizedBox(height: 8),
        if (inService.isEmpty)
          const _EmptyStateBox(text: 'No customer currently in service.'),
        ...inService.map((ticket) => _TicketCard(
              ticket: ticket,
              onTap: () => _showTicketDetailsDialog(ticket),
              onComplete: () {
                setState(() {
                  _repo.updateTicketStatus(ticket.id, QueueStatus.completed);
                });
              },
            )),
        const SizedBox(height: 20),

        // Waiting Queue Section
        _SectionHeader(
          title: 'Waiting in Line (${waiting.length})',
          color: Colors.orange,
        ),
        const SizedBox(height: 8),
        if (waiting.isEmpty)
          const _EmptyStateBox(text: 'Queue is clear! No customers waiting.'),
        ...waiting.map((ticket) => _TicketCard(
              ticket: ticket,
              onTap: () => _showTicketDetailsDialog(ticket),
              onCallNext: () {
                setState(() {
                  _repo.updateTicketStatus(ticket.id, QueueStatus.inService);
                });
              },
              onNoShow: () {
                setState(() {
                  _repo.updateTicketStatus(ticket.id, QueueStatus.noShow);
                });
              },
            )),
        const SizedBox(height: 20),

        // Completed Section
        _SectionHeader(
          title: 'Completed Today (${completed.length})',
          color: Colors.green,
        ),
        const SizedBox(height: 8),
        ...completed.map((ticket) => _TicketCard(
              ticket: ticket,
              onTap: () => _showTicketDetailsDialog(ticket),
            )),
      ],
    );
  }

  Widget _buildStaffView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Stylist & Barber Roster',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ..._repo.staff.map(
          (st) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.borderLg,
              border: Border.all(color: AppColors.border),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: AppRadius.borderLg,
              child: InkWell(
                borderRadius: AppRadius.borderLg,
                onTap: () => _showStaffDetailsDialog(st),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.softPink,
                        child: Text(
                          st.name[0],
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              st.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              st.role,
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ChoiceChip(
                        label: Text(st.isOnBreak ? 'On Break' : (st.isActive ? 'Active' : 'Off')),
                        selected: st.isActive,
                        onSelected: (val) {
                          setState(() {
                            _repo.toggleStaffStatus(st.id, isActive: val);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServicesView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Salon Services Catalog',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                _repo.addService('Custom Treatment', 30, 40.0);
                setState(() {});
              },
              icon: const Icon(Icons.add_rounded, size: 16),
              label: const Text('Add Service'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._repo.services.map(
          (srv) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.borderLg,
              border: Border.all(color: AppColors.border),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: AppRadius.borderLg,
              child: InkWell(
                borderRadius: AppRadius.borderLg,
                onTap: () => _showServiceDetailsDialog(srv),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              srv.title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${srv.durationMinutes} mins • ₹${srv.price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch.adaptive(
                        value: srv.isEnabled,
                        activeTrackColor: AppColors.primary,
                        onChanged: (val) {
                          setState(() {
                            _repo.toggleServiceStatus(srv.id, val);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsView(List<QueueTicket> completed) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Today\'s Performance',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadius.borderLg,
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              _StatItem(
                label: 'Total Revenue Today',
                value: '₹${(completed.length * 480 + 350).toStringAsFixed(0)}',
                color: Colors.green,
              ),
              const Divider(height: 24, color: AppColors.divider),
              _StatItem(
                label: 'Average Wait Time',
                value: '14 mins',
                color: AppColors.primary,
              ),
              const Divider(height: 24, color: AppColors.divider),
              _StatItem(
                label: 'Walk-ins Served',
                value: '${completed.where((t) => t.isWalkIn).length}',
                color: Colors.blue,
              ),
              const Divider(height: 24, color: AppColors.divider),
              _StatItem(
                label: 'Customer Rating Today',
                value: '4.9 ★',
                color: Colors.amber[800]!,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _KpiMetric extends StatelessWidget {
  const _KpiMetric({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.color});
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _EmptyStateBox extends StatelessWidget {
  const _EmptyStateBox({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({
    required this.ticket,
    this.onTap,
    this.onCallNext,
    this.onComplete,
    this.onNoShow,
  });

  final QueueTicket ticket;
  final VoidCallback? onTap;
  final VoidCallback? onCallNext;
  final VoidCallback? onComplete;
  final VoidCallback? onNoShow;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.borderLg,
        border: Border.all(
          color: ticket.status == QueueStatus.inService
              ? AppColors.primary
              : AppColors.border,
          width: ticket.status == QueueStatus.inService ? 1.5 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.borderLg,
        child: InkWell(
          borderRadius: AppRadius.borderLg,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.softPink,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            ticket.ticketNumber,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          ticket.customerName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        if (ticket.isWalkIn) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Walk-in',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (ticket.status == QueueStatus.waiting)
                      Text(
                        '~${ticket.estimatedWaitMinutes}m wait',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${ticket.serviceName} • Stylist: ${ticket.stylistName}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (onCallNext != null || onComplete != null) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: AppColors.divider),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (onNoShow != null)
                        TextButton(
                          onPressed: onNoShow,
                          child: const Text(
                            'No-show',
                            style: TextStyle(color: Colors.red, fontSize: 13),
                          ),
                        ),
                      if (onCallNext != null)
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
                          ),
                          onPressed: onCallNext,
                          icon: const Icon(Icons.chair_rounded, size: 16),
                          label: const Text('Call to Chair'),
                        ),
                      if (onComplete != null)
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
                          ),
                          onPressed: onComplete,
                          icon: const Icon(Icons.check_rounded, size: 16),
                          label: const Text('Mark Done'),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
