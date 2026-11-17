/// A service category highlighted on the customer dashboard.
class PopularService {
  const PopularService({
    required this.name,
    required this.tagline,
    required this.startingPrice,
    required this.durationMin,
  });

  final String name;
  final String tagline;
  final int startingPrice;
  final int durationMin;
}
