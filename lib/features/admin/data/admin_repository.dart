import 'models/admin_models.dart';

class AdminRepository {
  AdminRepository._();
  static final AdminRepository instance = AdminRepository._();

  final List<AdminSalonModel> _salons = [
    AdminSalonModel(
      id: 'sal-1',
      name: 'Luxe Cut Studio',
      ownerName: 'Elena Rostova',
      ownerEmail: 'elena@luxecut.com',
      city: 'Downtown, NY',
      appliedDate: '12 Oct 2026',
      commissionRate: 12.0,
      status: SalonApprovalStatus.approved,
      monthlyRevenue: 14250.0,
      rating: 4.9,
    ),
    AdminSalonModel(
      id: 'sal-2',
      name: 'The Crown Barber Lounge',
      ownerName: 'Marcus Vance',
      ownerEmail: 'marcus@crownbarber.com',
      city: 'Brooklyn, NY',
      appliedDate: '01 Nov 2026',
      commissionRate: 15.0,
      status: SalonApprovalStatus.approved,
      monthlyRevenue: 9800.0,
      rating: 4.8,
    ),
    AdminSalonModel(
      id: 'sal-3',
      name: 'Velvet Glow Aesthetics',
      ownerName: 'Sarah Jenkins',
      ownerEmail: 'sarah@velvetglow.com',
      city: 'Manhattan, NY',
      appliedDate: '18 Nov 2026',
      commissionRate: 15.0,
      status: SalonApprovalStatus.pending,
      monthlyRevenue: 0.0,
      rating: 0.0,
    ),
    AdminSalonModel(
      id: 'sal-4',
      name: 'Urban Edge Hair Studio',
      ownerName: 'Tony Ramirez',
      ownerEmail: 'tony@urbanedge.com',
      city: 'Queens, NY',
      appliedDate: '20 Nov 2026',
      commissionRate: 12.0,
      status: SalonApprovalStatus.pending,
      monthlyRevenue: 0.0,
      rating: 0.0,
    ),
  ];

  final List<AdminUserModel> _users = [
    AdminUserModel(
      id: 'usr-1',
      name: 'Khushi Kalariya',
      email: 'kkalariya988@rku.ac.in',
      role: 'Super Admin',
      joinedDate: 'Jan 2026',
    ),
    AdminUserModel(
      id: 'usr-2',
      name: 'Alex Turner',
      email: 'alex.turner@example.com',
      role: 'Customer',
      joinedDate: 'Aug 2026',
    ),
    AdminUserModel(
      id: 'usr-3',
      name: 'Elena Rostova',
      email: 'elena@luxecut.com',
      role: 'Manager',
      joinedDate: 'Oct 2026',
    ),
    AdminUserModel(
      id: 'usr-4',
      name: 'Devin Cole',
      email: 'devin.badactor@test.com',
      role: 'Customer',
      joinedDate: 'Nov 2026',
      isBanned: true,
    ),
  ];

  final List<AdminCampaignModel> _campaigns = [
    AdminCampaignModel(
      id: 'cmp-1',
      code: 'SAVE20',
      title: '20% Platform Holiday Blast',
      discountPercent: 20,
      isActive: true,
      usageCount: 412,
    ),
    AdminCampaignModel(
      id: 'cmp-2',
      code: 'SAVE10',
      title: 'Welcome First Booking 10%',
      discountPercent: 10,
      isActive: true,
      usageCount: 1240,
    ),
    AdminCampaignModel(
      id: 'cmp-3',
      code: 'VIP50',
      title: 'Partner Salon Launch Promo',
      discountPercent: 50,
      isActive: false,
      usageCount: 88,
    ),
  ];

  final List<AdminPayoutRecord> _payouts = [
    AdminPayoutRecord(
      id: 'pay-1',
      salonName: 'Luxe Cut Studio',
      amount: 12540.0,
      date: '15 Nov 2026',
      status: 'Paid',
    ),
    AdminPayoutRecord(
      id: 'pay-2',
      salonName: 'The Crown Barber Lounge',
      amount: 8330.0,
      date: '15 Nov 2026',
      status: 'Paid',
    ),
    AdminPayoutRecord(
      id: 'pay-3',
      salonName: 'Luxe Cut Studio',
      amount: 3200.0,
      date: '22 Nov 2026',
      status: 'Pending',
    ),
  ];

  List<AdminSalonModel> get salons => List.unmodifiable(_salons);
  List<AdminUserModel> get users => List.unmodifiable(_users);
  List<AdminCampaignModel> get campaigns => List.unmodifiable(_campaigns);
  List<AdminPayoutRecord> get payouts => List.unmodifiable(_payouts);

  void updateSalonStatus(String id, SalonApprovalStatus status) {
    final idx = _salons.indexWhere((s) => s.id == id);
    if (idx != -1) {
      _salons[idx].status = status;
    }
  }

  void toggleUserBan(String id) {
    final idx = _users.indexWhere((u) => u.id == id);
    if (idx != -1) {
      _users[idx].isBanned = !_users[idx].isBanned;
    }
  }

  void toggleCampaign(String id) {
    final idx = _campaigns.indexWhere((c) => c.id == id);
    if (idx != -1) {
      _campaigns[idx].isActive = !_campaigns[idx].isActive;
    }
  }

  void addCampaign({
    required String code,
    required String title,
    required int discount,
  }) {
    _campaigns.add(
      AdminCampaignModel(
        id: 'cmp-${DateTime.now().millisecondsSinceEpoch}',
        code: code.toUpperCase(),
        title: title,
        discountPercent: discount,
        isActive: true,
        usageCount: 0,
      ),
    );
  }
}
