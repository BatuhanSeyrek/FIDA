import 'dart:convert';
import 'package:fida/core/secure_stroge.dart';
import 'package:fida/models/ExpenseModel.dart';
import 'package:fida/models/ExpenseRequest.dart';
import 'package:http/http.dart' as http;

class ExpenseService {
  final SecureStorage _storage = SecureStorage();

  Future<bool> recordExpense(ExpenseRequest request) async {
    try {
      // 1. Token'ı SecureStorage'dan oku
      String? token = await _storage.readToken();

      if (token == null) return false;

      // 2. İsteği gönder (Header'a Bearer token ekle)
      final response = await http.post(
        Uri.parse(
          "https://antone-unupbraiding-stephine.ngrok-free.dev/expenses/record",
        ),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(request.toJson()),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Harcama Kayıt Hatası: $e");
      return false;
    }
  }

  Future<List<ExpenseModel>> fetchExpenses() async {
    try {
      // 1. Token'ı depodan oku
      final String? token = await _storage.readToken();

      // 2. İsteği gönderirken başlığa (Header) ekle
      final response = await http.get(
        Uri.parse(
          "https://antone-unupbraiding-stephine.ngrok-free.dev/expenses/expensesList",
        ),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Token burada ekleniyor
        },
      );

      if (response.statusCode == 200) {
        // Türkçe karakterler için utf8.decode kullanımı
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        return body.map((item) => ExpenseModel.fromJson(item)).toList();
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw "Yetkilendirme hatası: Giriş yapmanız gerekiyor.";
      } else {
        throw "Sunucu hatası: ${response.statusCode}";
      }
    } catch (e) {
      print("Bağlantı Hatası: $e");
      // Hata durumunda boş liste döner veya yukarıya hata fırlatır
      return [];
    }
  }
}
