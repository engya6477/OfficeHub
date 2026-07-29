import '../mock/mock_seed.dart';
import '../models/employee.dart';
import 'session_repository.dart';

class MockSessionRepository implements SessionRepository {
  @override
  Employee get currentEmployee => MockSeed.currentEmployee;

  Future<void> _simulateRoundTrip() => Future.delayed(const Duration(milliseconds: 500));

  @override
  Future<void> signIn({required String email, required String password}) async {
    await _simulateRoundTrip();
    if (email.trim().isEmpty || password.trim().isEmpty) {
      throw const AuthException('Enter your work email and password.');
    }
  }

  @override
  Future<void> signUp({required String name, required String email, required String password}) async {
    await _simulateRoundTrip();
    if (name.trim().isEmpty || email.trim().isEmpty || password.trim().isEmpty) {
      throw const AuthException('Please complete all fields to create your account.');
    }
  }

  @override
  Future<void> sendPasswordReset({required String email}) async {
    await _simulateRoundTrip();
    if (email.trim().isEmpty) {
      throw const AuthException('Enter your work email.');
    }
  }
}
