/// A salon shown in the customer-facing lists.
class Salon {
  const Salon({
    required this.name,
    required this.rating,
    required this.reviewCount,
    required this.distanceKm,
    required this.address,
    required this.popularServices,
    required this.startingPrice,
    this.isOpen = true,
  });

  final String name;
  final double rating;
  final int reviewCount;
  final double distanceKm;
  final String address;
  final List<String> popularServices;
  final int startingPrice;
  final bool isOpen;

  String get initial =>
      name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();
}
