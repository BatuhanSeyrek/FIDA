import 'package:fida/models/UserModel.dart';
import 'package:flutter/material.dart';
import '../services/UserService.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  final UserService _userService = UserService();

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> loadUserData(String token) async {
    _isLoading = true;
    notifyListeners();
    _user = await _userService.fetchUserProfile(token);
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateUserInfo(UserModel updatedUser, String token) async {
    _isLoading = true;
    notifyListeners();
    final result = await _userService.updateUser(updatedUser, token);
    if (result != null) {
      _user = result; // Local veriyi güncelle, ekran anında değişir
      _isLoading = false;
      notifyListeners();
      return true;
    }
    _isLoading = false;
    notifyListeners();
    return false;
  }
}
