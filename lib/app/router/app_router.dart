import 'package:flutter/material.dart';

import 'route_names.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/auth/presentation/pages/success_page.dart';
import '../../features/user/presentation/pages/user_home_page.dart';
import '../../features/user/presentation/pages/salons_list_page.dart';
import '../../features/user/presentation/pages/salon_detail_page.dart';
import '../../features/user/presentation/pages/appointments_page.dart';
import '../../features/user/presentation/pages/search_page.dart';
import '../../features/user/presentation/pages/select_date_time_page.dart';
import '../../features/user/presentation/pages/booking_summary_page.dart';
import '../../features/user/presentation/pages/payment_page.dart';
import '../../features/user/presentation/pages/live_queue_ticket_page.dart';
import '../../features/user/presentation/pages/user_profile_page.dart';
import '../../features/user/presentation/pages/offers_page.dart';
import '../../features/manager/presentation/pages/manager_dashboard_page.dart';
import '../../features/admin/presentation/pages/admin_dashboard_page.dart';
import '../../features/user/data/models/salon.dart';
import '../../features/user/data/mock_user_data.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.initial:
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());

      // Auth Flow
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case RouteNames.signUp:
        return MaterialPageRoute(builder: (_) => const SignUpPage());

      case RouteNames.otpVerification:
        final purpose = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => OtpVerificationPage(
            purpose: purpose is OtpPurpose ? purpose : OtpPurpose.resetPassword,
          ),
        );

      case RouteNames.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());

      case RouteNames.resetPassword:
        return MaterialPageRoute(builder: (_) => const ResetPasswordPage());

      case RouteNames.success:
        final args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => args is SuccessArgs
              ? SuccessPage(
                  title: args.title,
                  subtitle: args.subtitle,
                  buttonText: args.buttonText,
                )
              : const SuccessPage(),
        );

      // Customer Flow
      case RouteNames.userHome:
        return MaterialPageRoute(builder: (_) => const UserHomePage());

      case RouteNames.userSalons:
        return MaterialPageRoute(builder: (_) => const SalonsListPage());

      case RouteNames.userSalonDetails:
        final salon = settings.arguments is Salon
            ? settings.arguments as Salon
            : MockUserData.topSalons.first;
        return MaterialPageRoute(
          builder: (_) => SalonDetailPage(salon: salon),
        );

      case RouteNames.userAppointments:
        return MaterialPageRoute(builder: (_) => const AppointmentsPage());

      case RouteNames.userProfile:
        return MaterialPageRoute(builder: (_) => const UserProfilePage());

      case RouteNames.userOffers:
        return MaterialPageRoute(builder: (_) => const OffersPage());

      case RouteNames.userSearch:
        return MaterialPageRoute(builder: (_) => const SearchPage());

      case RouteNames.userLiveQueueTicket:
        return MaterialPageRoute(builder: (_) => const LiveQueueTicketPage());

      case RouteNames.userSelectDateTime:
        return MaterialPageRoute(
          builder: (_) => const SelectDateTimePage(),
        );

      case RouteNames.userBookingSummary:
        final summaryArguments = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => BookingSummaryPage(
            salon: summaryArguments is Salon
                ? summaryArguments
                : MockUserData.topSalons.first,
            selectedStylist:
                summaryArguments is Stylist
                    ? summaryArguments
                    : MockUserData.stylists.first,
            selectedDate: (summaryArguments is DateTime)
                ? summaryArguments
                : DateTime.now().add(const Duration(days: 1)),
            selectedSlot: (summaryArguments is String)
                ? summaryArguments
                : '11:00 AM',
          ),
        );

      case RouteNames.userPayment:
        final paymentArgs = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => PaymentPage(
            salon: paymentArgs is Salon
                ? paymentArgs
                : MockUserData.topSalons.first,
            selectedStylist:
                paymentArgs is Stylist
                    ? paymentArgs
                    : MockUserData.stylists.first,
            selectedDate: (paymentArgs is DateTime)
                ? paymentArgs
                : DateTime.now().add(const Duration(days: 1)),
            selectedSlot: (paymentArgs is String)
                ? paymentArgs
                : '11:00 AM',
            servicePrice: 299,
            subtotal: 299,
            tax: 35.88,
            couponDiscount: 0,
            total: 334.88,
          ),
        );

      // Manager Flow
      case RouteNames.managerLogin:
      case RouteNames.managerDashboard:
        return MaterialPageRoute(builder: (_) => const ManagerDashboardPage());

      // Super Admin Flow
      case RouteNames.adminLogin:
      case RouteNames.adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashboardPage());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
