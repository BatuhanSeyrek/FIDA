import 'dart:convert';
import 'package:fida/models/UserModel.dart';
import 'package:http/http.dart' as http;

class UserService {
  Future<UserModel?> fetchUserProfile(String token) async {
    final response = await http.get(
      Uri.parse(
        "https://antone-unupbraiding-stephine.ngrok-free.dev/user/list",
      ),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    }
    return null;
  }

  Future<UserModel?> updateUser(UserModel user, String token) async {
    final response = await http.post(
      Uri.parse(
        "https://antone-unupbraiding-stephine.ngrok-free.dev/user/update",
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(user.toJson()),
    );
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    }
    return null;
  }
}
