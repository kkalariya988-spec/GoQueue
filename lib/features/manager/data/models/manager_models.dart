enum QueueStatus { waiting, inService, completed, noShow }

class QueueTicket {
  QueueTicket({
    required this.id,
    required this.ticketNumber,
    required this.customerName,
    required this.serviceName,
    required this.stylistName,
    required this.estimatedWaitMinutes,
    required this.joinedAt,
    this.status = QueueStatus.waiting,
    this.isWalkIn = false,
  });

  final String id;
  final String ticketNumber;
  final String customerName;
  final String serviceName;
  final String stylistName;
  final int estimatedWaitMinutes;
  final DateTime joinedAt;
  QueueStatus status;
  final bool isWalkIn;

  QueueTicket copyWith({
    String? id,
    String? ticketNumber,
    String? customerName,
    String? serviceName,
    String? stylistName,
    int? estimatedWaitMinutes,
    DateTime? joinedAt,
    QueueStatus? status,
    bool? isWalkIn,
  }) {
    return QueueTicket(
      id: id ?? this.id,
      ticketNumber: ticketNumber ?? this.ticketNumber,
      customerName: customerName ?? this.customerName,
      serviceName: serviceName ?? this.serviceName,
      stylistName: stylistName ?? this.stylistName,
      estimatedWaitMinutes: estimatedWaitMinutes ?? this.estimatedWaitMinutes,
      joinedAt: joinedAt ?? this.joinedAt,
      status: status ?? this.status,
      isWalkIn: isWalkIn ?? this.isWalkIn,
    );
  }
}

class ManagerStaffMember {
  ManagerStaffMember({
    required this.id,
    required this.name,
    required this.role,
    this.isActive = true,
    this.isOnBreak = false,
    this.currentTicket,
  });

  final String id;
  final String name;
  final String role;
  bool isActive;
  bool isOnBreak;
  String? currentTicket;
}

class ManagerServiceItem {
  ManagerServiceItem({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.price,
    this.isEnabled = true,
  });

  final String id;
  final String title;
  final int durationMinutes;
  final double price;
  bool isEnabled;
}
