import 'dart:convert';
import 'package:fida/core/secure_stroge.dart'; // Yazım hatası olabilir, secure_storage.dart mı?
import 'package:http/http.dart' as http;
import '../models/IncomeModel.dart';

class IncomeService {
  final SecureStorage _storage = SecureStorage();

  // Header hazırlayan yardımcı metod (Tüm isteklere bunu ekliyoruz)
  Future<Map<String, String>> _getHeaders() async {
    final token = await _storage.readToken();
    return {
      "Content-Type": "application/json",
      "Authorization":
          "Bearer ${token ?? ''}", // Token null ise boş gönderir, backend 401 döner
    };
  }

  // GET: Gelir Listeleme
  Future<IncomeModel?> fetchIncome() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse(
          "https://antone-unupbraiding-stephine.ngrok-free.dev/income/list",
        ),
        headers: headers,
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return IncomeModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print("Fetch Income Error: $e");
    }
    return null;
  }

  // POST: Gelir Kaydetme
  Future<bool> recordIncome(double amount) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(
          "https://antone-unupbraiding-stephine.ngrok-free.dev/income/record",
        ),
        headers: headers,
        body: jsonEncode({'income': amount}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Record Income Error: $e");
      return false;
    }
  }

  // DELETE: Gelir Silme
  Future<bool> deleteIncome() async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse(
          "https://antone-unupbraiding-stephine.ngrok-free.dev/income/delete",
        ),
        headers: headers,
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Delete Income Error: $e");
      return false;
    }
  }
}
