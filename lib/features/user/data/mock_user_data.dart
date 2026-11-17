import 'models/popular_service.dart';
import 'models/salon.dart';

/// Local demo content used by the customer dashboard until the API exists.
class MockUserData {
  MockUserData._();

  static const List<PopularService> popularServices = [
    PopularService(
      name: 'Haircut',
      tagline: 'Fresh look, new you',
      startingPrice: 299,
      durationMin: 30,
    ),
    PopularService(
      name: 'Hair Styling',
      tagline: 'For every occasion',
      startingPrice: 499,
      durationMin: 60,
    ),
    PopularService(
      name: 'Hair Coloring',
      tagline: 'Add a splash of color',
      startingPrice: 999,
      durationMin: 90,
    ),
    PopularService(
      name: 'Makeup',
      tagline: 'Be your own kind of beautiful',
      startingPrice: 1299,
      durationMin: 45,
    ),
  ];

  static const List<Salon> topSalons = [
    Salon(
      name: 'Glow & Glam Salon',
      rating: 4.8,
      reviewCount: 1200,
      distanceKm: 2.5,
      address: 'Sector 14, Rajkot',
      popularServices: ['Haircut', 'Hair Styling'],
      startingPrice: 2299,
    ),
    Salon(
      name: 'Style Studio',
      rating: 4.7,
      reviewCount: 932,
      distanceKm: 4.1,
      address: 'JK Chowk, Rajkot',
      popularServices: ['Hair Coloring'],
      startingPrice: 2399,
    ),
    Salon(
      name: 'Luxe Salon & Spa',
      rating: 4.5,
      reviewCount: 178,
      distanceKm: 3.1,
      address: 'Kalawad Road, Rajkot',
      popularServices: ['Hair Spa', 'Facial'],
      startingPrice: 1799,
    ),
  ];
}
