/// A service category highlighted on the customer dashboard.
class PopularService {
  const PopularService({
    required this.name,
    required this.tagline,
    required this.startingPrice,
  });

  final String name;
  final String tagline;
  final int startingPrice;
}
