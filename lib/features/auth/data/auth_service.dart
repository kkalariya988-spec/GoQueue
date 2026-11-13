/// In-memory auth used while the app has no backend.
///
/// Only the demo account below can sign in. Replace this service with the
/// real repository once authentication is connected to the API.
class AuthUser {
  const AuthUser({required this.name, required this.email});

  final String name;
  final String email;
}

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  // Demo credentials for local testing.
  static const String demoName = 'Khushi Kalariya';
  static const String demoEmail = 'kkalariya988@rku.ac.in';
  static const String demoPassword = '123456';

  AuthUser? _currentUser;

  AuthUser? get currentUser => _currentUser;

  /// Returns the signed-in user, or `null` when the credentials do not match
  /// the demo account.
  Future<AuthUser?> login({
    required String name,
    required String email,
    required String password,
    Duration delay = const Duration(milliseconds: 450),
  }) async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }

    final matches =
        name.trim().toLowerCase() == demoName.toLowerCase() &&
        email.trim().toLowerCase() == demoEmail.toLowerCase() &&
        password == demoPassword;

    if (!matches) {
      return null;
    }

    final user = AuthUser(name: demoName, email: demoEmail);
    _currentUser = user;
    return user;
  }

  void logout() {
    _currentUser = null;
  }
}
