import 'package:flutter/foundation.dart';

import '../data/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._authService);

  final AuthService _authService;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null && _errorMessage!.isNotEmpty;
  String? get userEmail => _authService.currentUser?.email;
  String? get userId => _authService.currentUser?.uid;
  bool get isSignedIn => _authService.isSignedIn;
  DateTime? get lastSignInTime => _authService.lastSignInTime;
  Stream<Object?> get authStateChanges => _authService.authStateChanges;

  void clearError() {
    if (_errorMessage == null) {
      return;
    }
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> register(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.register(email, password);
      return true;
    } catch (error) {
      _errorMessage = _normalizeError(error);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.login(email, password);
      return true;
    } catch (error) {
      _errorMessage = _normalizeError(error);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> logout() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.logout();
      return true;
    } catch (error) {
      _errorMessage = _normalizeError(error);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.resetPassword(email);
      return true;
    } catch (error) {
      _errorMessage = _normalizeError(error);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> validatePersistedSession() async {
    final user = _authService.currentUser;
    if (user == null) {
      return null;
    }

    try {
      await user.reload();
      return null;
    } catch (_) {
      await _authService.logout();
      return 'Your session has expired. Please sign in again.';
    }
  }

  String _normalizeError(Object error) {
    final message = error.toString();
    if (message.startsWith('Exception: ')) {
      return message.substring('Exception: '.length);
    }
    return message;
  }
}
