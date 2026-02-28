import 'dart:convert';
import 'package:fida/models/UserModel.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl = "http://10.0.2.2:8080/user";

  Future<UserModel?> fetchUserProfile(String token) async {
    final response = await http.get(
      Uri.parse("$baseUrl/list"),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    }
    return null;
  }

  Future<UserModel?> updateUser(UserModel user, String token) async {
    final response = await http.post(
      Uri.parse("$baseUrl/update"),
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
