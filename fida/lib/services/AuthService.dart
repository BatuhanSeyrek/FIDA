import 'dart:convert';
import 'package:fida/models/LoginResponse.dart';
import 'package:fida/models/RegisterRequest.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // Emülatör kullanıyorsan 10.0.2.2, fiziksel cihaz ise bilgisayar IP'ni yazmalısın.
  final String baseUrl = "http://10.0.2.2:8080/user/login";

  Future<LoginResponse?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print("Bağlantı Hatası: $e");
      return null;
    }
  }

  Future<bool> register(RegisterRequest request) async {
    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:8080/user/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request.toJson()),
      );

      // Backend 200 OK veya 201 Created dönüyorsa başarılıdır
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Register Hatası: $e");
      return false;
    }
  }
}
