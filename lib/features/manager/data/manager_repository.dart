import 'models/manager_models.dart';

class ManagerRepository {
  ManagerRepository._();
  static final ManagerRepository instance = ManagerRepository._();

  final List<QueueTicket> _tickets = [
    QueueTicket(
      id: 'q-101',
      ticketNumber: 'A-12',
      customerName: 'Marcus Vance',
      serviceName: 'Fade & Beard Sculpt',
      stylistName: 'Elena Rostova',
      estimatedWaitMinutes: 5,
      joinedAt: DateTime.now().subtract(const Duration(minutes: 15)),
      status: QueueStatus.inService,
    ),
    QueueTicket(
      id: 'q-102',
      ticketNumber: 'A-13',
      customerName: 'Sophia Chen',
      serviceName: 'Balayage & Blow Dry',
      stylistName: 'Marcus Vance',
      estimatedWaitMinutes: 12,
      joinedAt: DateTime.now().subtract(const Duration(minutes: 10)),
      status: QueueStatus.waiting,
    ),
    QueueTicket(
      id: 'q-103',
      ticketNumber: 'A-14',
      customerName: 'Liam O’Connor',
      serviceName: 'Classic Cut & Wash',
      stylistName: 'Any Stylist',
      estimatedWaitMinutes: 25,
      joinedAt: DateTime.now().subtract(const Duration(minutes: 5)),
      status: QueueStatus.waiting,
    ),
    QueueTicket(
      id: 'q-104',
      ticketNumber: 'W-01',
      customerName: 'David Miller (Walk-in)',
      serviceName: 'Quick Trim',
      stylistName: 'Elena Rostova',
      estimatedWaitMinutes: 35,
      joinedAt: DateTime.now().subtract(const Duration(minutes: 2)),
      status: QueueStatus.waiting,
      isWalkIn: true,
    ),
    QueueTicket(
      id: 'q-100',
      ticketNumber: 'A-11',
      customerName: 'Emma Watson',
      serviceName: 'Keratin Smoothing',
      stylistName: 'Chloe Bennett',
      estimatedWaitMinutes: 0,
      joinedAt: DateTime.now().subtract(const Duration(minutes: 60)),
      status: QueueStatus.completed,
    ),
  ];

  final List<ManagerStaffMember> _staff = [
    ManagerStaffMember(
      id: 'st-1',
      name: 'Elena Rostova',
      role: 'Master Stylist',
      isActive: true,
      isOnBreak: false,
      currentTicket: 'A-12',
    ),
    ManagerStaffMember(
      id: 'st-2',
      name: 'Marcus Vance',
      role: 'Senior Barber',
      isActive: true,
      isOnBreak: false,
    ),
    ManagerStaffMember(
      id: 'st-3',
      name: 'Chloe Bennett',
      role: 'Colorist & Esthetician',
      isActive: true,
      isOnBreak: true,
    ),
    ManagerStaffMember(
      id: 'st-4',
      name: 'Julian Thorne',
      role: 'Junior Stylist',
      isActive: false,
      isOnBreak: false,
    ),
  ];

  final List<ManagerServiceItem> _services = [
    ManagerServiceItem(
      id: 'srv-1',
      title: 'Precision Haircut & Style',
      durationMinutes: 45,
      price: 45.0,
      isEnabled: true,
    ),
    ManagerServiceItem(
      id: 'srv-2',
      title: 'Luxury Beard Trim & Hot Towel',
      durationMinutes: 30,
      price: 30.0,
      isEnabled: true,
    ),
    ManagerServiceItem(
      id: 'srv-3',
      title: 'Full Balayage & Toning',
      durationMinutes: 120,
      price: 160.0,
      isEnabled: true,
    ),
    ManagerServiceItem(
      id: 'srv-4',
      title: 'Deep Conditioning & Scalp Massage',
      durationMinutes: 40,
      price: 55.0,
      isEnabled: true,
    ),
  ];

  List<QueueTicket> get tickets => List.unmodifiable(_tickets);
  List<ManagerStaffMember> get staff => List.unmodifiable(_staff);
  List<ManagerServiceItem> get services => List.unmodifiable(_services);

  void updateTicketStatus(String id, QueueStatus status) {
    final index = _tickets.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tickets[index].status = status;
    }
  }

  void addWalkIn({
    required String customerName,
    required String serviceName,
    required String stylistName,
  }) {
    final newNumber = 'W-0${_tickets.where((t) => t.isWalkIn).length + 1}';
    final ticket = QueueTicket(
      id: 'q-${DateTime.now().millisecondsSinceEpoch}',
      ticketNumber: newNumber,
      customerName: customerName,
      serviceName: serviceName,
      stylistName: stylistName,
      estimatedWaitMinutes: 20,
      joinedAt: DateTime.now(),
      status: QueueStatus.waiting,
      isWalkIn: true,
    );
    _tickets.add(ticket);
  }

  void toggleStaffStatus(String id, {bool? isActive, bool? isOnBreak}) {
    final member = _staff.firstWhere((s) => s.id == id);
    if (isActive != null) member.isActive = isActive;
    if (isOnBreak != null) member.isOnBreak = isOnBreak;
  }

  void toggleServiceStatus(String id, bool isEnabled) {
    final service = _services.firstWhere((s) => s.id == id);
    service.isEnabled = isEnabled;
  }

  void addService(String title, int duration, double price) {
    _services.add(
      ManagerServiceItem(
        id: 'srv-${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        durationMinutes: duration,
        price: price,
      ),
    );
  }
}
