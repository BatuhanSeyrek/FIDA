import 'package:fida/core/secure_stroge.dart';
import 'package:fida/models/RegisterRequest.dart';
import 'package:fida/services/AuthService.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final SecureStorage _storage = SecureStorage();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    final response = await _authService.login(username, password);

    if (response != null && response.token != null) {
      // Senin yazdığın metod ile token'ı kaydediyoruz
      await _storage.writeToken(response.token!);

      _isLoading = false;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // AuthProvider içine eklenecekler:
  Future<bool> register(
    String name,
    String email,
    String pass,
    String phone,
  ) async {
    _isLoading = true;
    notifyListeners();

    final request = RegisterRequest(
      userName: name,
      email: email,
      password: pass,
      phoneNumber: phone,
    );

    bool success = await _authService.register(request);

    _isLoading = false;
    notifyListeners();
    return success;
  }
}
