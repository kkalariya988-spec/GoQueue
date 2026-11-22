import 'models/popular_service.dart';
import 'models/salon.dart';

class Stylist {
  const Stylist({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.experienceYears,
    this.isAvailable = true,
  });

  final String name;
  final String specialty;
  final double rating;
  final int experienceYears;
  final bool isAvailable;

  String get initial => name.trim().isEmpty ? 'S' : name.trim()[0].toUpperCase();
}

class SalonServiceItem {
  const SalonServiceItem({
    required this.name,
    required this.description,
    required this.price,
    required this.durationMin,
    required this.category,
  });

  final String name;
  final String description;
  final int price;
  final int durationMin;
  final String category;
}

class BookingItem {
  const BookingItem({
    required this.id,
    required this.salonName,
    required this.serviceName,
    required this.stylistName,
    required this.dateTime,
    required this.price,
    required this.isLiveQueue,
    this.queueToken,
    this.queuePosition,
    this.status = 'Confirmed',
  });

  final String id;
  final String salonName;
  final String serviceName;
  final String stylistName;
  final DateTime dateTime;
  final int price;
  final bool isLiveQueue;
  final String? queueToken;
  final int? queuePosition;
  final String status;
}

/// Local demo content used by the customer flow.
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
    PopularService(
      name: 'Beard Grooming',
      tagline: 'Sharp edges & trim',
      startingPrice: 199,
      durationMin: 20,
    ),
    PopularService(
      name: 'Facial & Cleanup',
      tagline: 'Skin rejuvenation',
      startingPrice: 799,
      durationMin: 50,
    ),
  ];

  static const List<Salon> topSalons = [
    Salon(
      name: 'Glow & Glam Salon',
      rating: 4.8,
      reviewCount: 1200,
      distanceKm: 2.5,
      address: 'Sector 14, Rajkot',
      popularServices: ['Haircut', 'Hair Styling', 'Hair Spa'],
      startingPrice: 299,
    ),
    Salon(
      name: 'Style Studio',
      rating: 4.7,
      reviewCount: 932,
      distanceKm: 4.1,
      address: 'JK Chowk, Rajkot',
      popularServices: ['Hair Coloring', 'Beard Trim'],
      startingPrice: 399,
    ),
    Salon(
      name: 'Luxe Salon & Spa',
      rating: 4.5,
      reviewCount: 178,
      distanceKm: 3.1,
      address: 'Kalawad Road, Rajkot',
      popularServices: ['Hair Spa', 'Facial', 'Manicure'],
      startingPrice: 799,
    ),
  ];

  static const List<Stylist> stylists = [
    Stylist(
      name: 'Rahul Sharma',
      specialty: 'Master Barber & Fade Specialist',
      rating: 4.9,
      experienceYears: 6,
      isAvailable: true,
    ),
    Stylist(
      name: 'Priya Patel',
      specialty: 'Hair Colorist & Stylist',
      rating: 4.8,
      experienceYears: 5,
      isAvailable: true,
    ),
    Stylist(
      name: 'Amit Varma',
      specialty: 'Skin & Facial Expert',
      rating: 4.7,
      experienceYears: 4,
      isAvailable: true,
    ),
    Stylist(
      name: 'Kavita Dave',
      specialty: 'Bridal & Grooming Artist',
      rating: 4.9,
      experienceYears: 7,
      isAvailable: false,
    ),
  ];

  static const List<SalonServiceItem> salonServices = [
    SalonServiceItem(
      name: 'Classic Precision Haircut',
      description: 'Consultation, hair wash, precision scissor cut, and styling.',
      price: 299,
      durationMin: 30,
      category: 'Hair',
    ),
    SalonServiceItem(
      name: 'Royal Beard Sculpt & Trim',
      description: 'Hot towel wrap, beard shaping, razor finish, and organic beard oil.',
      price: 199,
      durationMin: 25,
      category: 'Shave & Beard',
    ),
    SalonServiceItem(
      name: 'Global Hair Color & Gloss',
      description: 'Ammonia-free premium hair color with nourishing keratin shine.',
      price: 1199,
      durationMin: 75,
      category: 'Hair',
    ),
    SalonServiceItem(
      name: 'Deep Nourishing Hair Spa',
      description: 'Steam therapy, scalp massage, and intensive repair mask.',
      price: 699,
      durationMin: 45,
      category: 'Spa & Care',
    ),
    SalonServiceItem(
      name: 'Instant Glow Herbal Facial',
      description: 'Deep pore cleansing, gentle exfoliation, and soothing face mask.',
      price: 899,
      durationMin: 50,
      category: 'Spa & Care',
    ),
  ];

  // In-memory active bookings & queue entries for customer demonstration
  static final List<BookingItem> activeBookings = [
    BookingItem(
      id: 'GQ-9021',
      salonName: 'Glow & Glam Salon',
      serviceName: 'Classic Precision Haircut',
      stylistName: 'Rahul Sharma',
      dateTime: DateTime.now().add(const Duration(minutes: 20)),
      price: 299,
      isLiveQueue: true,
      queueToken: 'Q-08',
      queuePosition: 2,
      status: 'In Queue',
    ),
  ];
}
