import '../models/employee.dart';

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Data-layer abstraction for authentication/session state. No backend is
/// provided for this assessment, so [MockSessionRepository] simulates the
/// round trip without a real credential store.
abstract class SessionRepository {
  Employee get currentEmployee;

  Future<void> signIn({required String email, required String password});

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<void> sendPasswordReset({required String email});
}
