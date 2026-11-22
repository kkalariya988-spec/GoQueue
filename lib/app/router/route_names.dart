class RouteNames {
  RouteNames._();

  // Initial & Splash
  static const String initial = '/';
  static const String splash = '/splash';

  // Auth - Shared & User
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String forgotPassword = '/forgot-password';
  static const String otpVerification = '/otp-verification';
  static const String resetPassword = '/reset-password';
  static const String success = '/success';

  // User / Customer Flow
  static const String userHome = '/user/home';
  static const String userSalons = '/user/salons';
  static const String userSearch = '/user/search';
  static const String userSalonDetails = '/user/salon';
  static const String userServices = '/user/services';
  static const String userServiceDetails = '/user/service-details';
  static const String userStaff = '/user/staff';
  static const String userSelectDateTime = '/user/select-date-time';
  static const String userBookingSummary = '/user/booking-summary';
  static const String userPayment = '/user/payment';
  static const String userAppointments = '/user/appointments';
  static const String userProfile = '/user/profile';
  static const String userOffers = '/user/offers';
  static const String userMenu = '/user/menu';
  static const String userLiveQueueTicket = '/user/live-queue-ticket';

  // Manager Flow
  static const String managerLogin = '/manager/login';
  static const String managerDashboard = '/manager/dashboard';
  static const String managerSchedule = '/manager/schedule';
  static const String managerWorkingHours = '/manager/working-hours';
  static const String managerCustomers = '/manager/customers';
  static const String managerServices = '/manager/services';
  static const String managerStaff = '/manager/staff';
  static const String managerProfile = '/manager/profile';

  // Admin Flow
  static const String adminLogin = '/admin/login';
  static const String adminDashboard = '/admin/dashboard';
  static const String adminSalons = '/admin/salons';
  static const String adminManagers = '/admin/managers';
  static const String adminStaff = '/admin/staff';
  static const String adminCustomers = '/admin/customers';
  static const String adminOffers = '/admin/offers';
  static const String adminPayments = '/admin/payments';
  static const String adminReports = '/admin/reports';
  static const String adminRoles = '/admin/roles';
  static const String adminProfile = '/admin/profile';
}
