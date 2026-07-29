import 'package:flutter/foundation.dart';

import '../../../data/repositories/session_repository.dart';

enum AuthStatus { unauthenticated, authenticated }

/// App-wide session state. Since no backend is provided, authentication is
/// mocked and not persisted across app restarts.
class AuthController extends ChangeNotifier {
  AuthController(this._sessionRepository);

  final SessionRepository _sessionRepository;

  AuthStatus _status = AuthStatus.unauthenticated;
  AuthStatus get status => _status;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  bool isLoading = false;
  String? errorMessage;

  Future<bool> signIn({required String email, required String password}) =>
      _run(() => _sessionRepository.signIn(email: email, password: password));

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) => _run(
    () =>
        _sessionRepository.signUp(name: name, email: email, password: password),
  );

  Future<bool> sendPasswordReset({required String email}) => _run(
    () => _sessionRepository.sendPasswordReset(email: email),
    authenticateOnSuccess: false,
  );

  void signOut() {
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<bool> _run(
    Future<void> Function() action, {
    bool authenticateOnSuccess = true,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await action();
      if (authenticateOnSuccess) {
        _status = AuthStatus.authenticated;
      }
      return true;
    } on AuthException catch (e) {
      errorMessage = e.message;
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
