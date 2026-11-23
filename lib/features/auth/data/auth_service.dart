/// In-memory auth used while the app has no backend.
///
/// Only the demo account below can sign in. Replace this service with the
/// real repository once authentication is connected to the API.
class AuthUser {
  const AuthUser({
    required this.name,
    required this.email,
    required this.role,
  });

  final String name;
  final String email;
  final String role; // 'admin', 'manager', 'customer'
}

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  // Pre-configured testing accounts:
  static const List<Map<String, String>> demoAccounts = [
    {
      'role': 'customer',
      'name': 'Khushi Kalariya',
      'email': 'khushi@goqueue.com',
      'password': '123456',
    },
    {
      'role': 'admin',
      'name': 'Khushi Admin',
      'email': 'kkalariya988@rku.ac.in',
      'password': '123456',
    },
    {
      'role': 'manager',
      'name': 'Dharmi Lunagariya',
      'email': 'dharmi@goqueue.com',
      'password': '123456',
    },
    {
      'role': 'customer',
      'name': 'Kumkum Gadhiya',
      'email': 'kumkum@goqueue.com',
      'password': '123456',
    },
  ];

  static String get demoName => demoAccounts.first['name']!;
  static String get demoEmail => demoAccounts.first['email']!;
  static String get demoPassword => demoAccounts.first['password']!;

  AuthUser? _currentUser;

  AuthUser? get currentUser => _currentUser;

  /// Returns the signed-in user, or `null` when credentials do not match.
  /// If [name] is empty or not matched, it authenticates by [email] & [password].
  Future<AuthUser?> login({
    String? name,
    required String email,
    required String password,
    Duration delay = const Duration(milliseconds: 300),
  }) async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }

    final trimmedEmail = email.trim().toLowerCase();
    final trimmedPass = password.trim();

    for (final acc in demoAccounts) {
      final accEmail = acc['email']!.toLowerCase();
      final accPass = acc['password']!;

      if (trimmedEmail == accEmail && trimmedPass == accPass) {
        final resolvedName = (name != null && name.trim().isNotEmpty)
            ? name.trim()
            : acc['name']!;
        final user = AuthUser(
          name: resolvedName,
          email: acc['email']!,
          role: acc['role']!,
        );
        _currentUser = user;
        return user;
      }
    }

    return null;
  }

  void logout() {
    _currentUser = null;
  }
}
