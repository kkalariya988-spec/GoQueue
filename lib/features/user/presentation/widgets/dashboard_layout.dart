/// Shared measurements for the responsive customer dashboard.
class DashboardLayout {
  DashboardLayout._();

  static const double maxContentWidth = 1200;

  static double pagePadding(double width) {
    if (width >= 900) return 40;
    if (width >= 600) return 32;
    if (width < 360) return 16;
    return 20;
  }
}
