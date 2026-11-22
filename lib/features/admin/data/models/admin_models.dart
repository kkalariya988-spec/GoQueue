enum SalonApprovalStatus { pending, approved, rejected }

class AdminSalonModel {
  AdminSalonModel({
    required this.id,
    required this.name,
    required this.ownerName,
    required this.ownerEmail,
    required this.city,
    required this.appliedDate,
    required this.commissionRate,
    this.status = SalonApprovalStatus.approved,
    this.monthlyRevenue = 0.0,
    this.rating = 4.8,
  });

  final String id;
  final String name;
  final String ownerName;
  final String ownerEmail;
  final String city;
  final String appliedDate;
  double commissionRate;
  SalonApprovalStatus status;
  double monthlyRevenue;
  double rating;
}

class AdminUserModel {
  AdminUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.joinedDate,
    this.isBanned = false,
  });

  final String id;
  final String name;
  final String email;
  final String role; // 'Customer', 'Manager', 'Admin'
  final String joinedDate;
  bool isBanned;
}

class AdminCampaignModel {
  AdminCampaignModel({
    required this.id,
    required this.code,
    required this.title,
    required this.discountPercent,
    required this.isActive,
    required this.usageCount,
  });

  final String id;
  final String code;
  final String title;
  final int discountPercent;
  bool isActive;
  int usageCount;
}

class AdminPayoutRecord {
  AdminPayoutRecord({
    required this.id,
    required this.salonName,
    required this.amount,
    required this.date,
    required this.status,
  });

  final String id;
  final String salonName;
  final double amount;
  final String date;
  final String status; // 'Paid', 'Pending'
}
