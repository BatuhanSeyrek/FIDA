import 'package:flutter/material.dart';
import 'package:fida/services/expense_service.dart';
import 'package:fida/models/ExpenseModel.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  static const colorDarkBlue = Color(0xFF14183e);
  static const colorBordo = Color(0xFF9c1132);
  static const colorDarkBordo = Color(0xFF821034);

  final List<Map<String, String>> messages = [];
  final TextEditingController _controller = TextEditingController();
  final ExpenseService _expenseService = ExpenseService();

  bool _isLoading = false;

  final String apiKey = "BURAYA_API_KEY";

  // 🔥 SELAMLAMA
  bool _isGreeting(String text) {
    final t = text.toLowerCase();
    return t.contains("merhaba") ||
        t.contains("selam") ||
        t.contains("hello") ||
        t.contains("hi");
  }

  // 🔥 SMALL TALK
  bool _isSmallTalk(String text) {
    final t = text.toLowerCase();
    return t.contains("naber") ||
        t.contains("nasılsın") ||
        t.contains("iyi misin");
  }

  // 🔥 AKILLI CONTEXT
  String _createSmartContext(List<ExpenseModel> expenses) {
    if (expenses.isEmpty) return "Hiç harcama yok.";

    Map<String, double> monthlyTotals = {};
    Map<String, double> categoryTotals = {};

    for (var e in expenses) {
      String month = DateFormat('yyyy-MM').format(e.createdAt);

      monthlyTotals[month] = (monthlyTotals[month] ?? 0) + e.amount;
      categoryTotals[e.type] = (categoryTotals[e.type] ?? 0) + e.amount;
    }

    String result = "📊 Aylık Harcamalar:\n";
    monthlyTotals.forEach((m, t) {
      result += "- $m : ${t.toStringAsFixed(0)} TL\n";
    });

    result += "\n📂 Kategori Bazlı:\n";
    categoryTotals.forEach((c, t) {
      result += "- $c : ${t.toStringAsFixed(0)} TL\n";
    });

    return result;
  }

  Future<void> sendMessage() async {
    if (_controller.text.isEmpty || _isLoading) return;

    String userText = _controller.text;
    _controller.clear();

    setState(() {
      messages.add({"sender": "user", "text": userText});
      _isLoading = true;
    });

    // 😄 SELAMLAMA
    if (_isGreeting(userText)) {
      List<String> replies = [
        "Merhaba! 😄 Hazır mısın bugün bütçeyi üzmeye?",
        "Selam! Bugün para harcamıyoruz dimi? 👀",
        "Merhaba! Cüzdanın nasıl, hâlâ hayatta mı? 💸",
        "Selam! Finansal durumunu birlikte kurtaralım mı? 😎",
      ];

      replies.shuffle();

      setState(() {
        messages.add({"sender": "bot", "text": replies.first});
        _isLoading = false;
      });
      return;
    }

    // 💬 SMALL TALK
    if (_isSmallTalk(userText)) {
      List<String> replies = [
        "İyiyim 😄 ama senin harcamalar biraz hasta gibi 👀",
        "Ben iyiyim, cüzdanın nasıl? Hâlâ direniyor mu? 💸",
        "Gayet iyiyim! Ama bütçen biraz stresli görünüyor 😅",
      ];

      replies.shuffle();

      setState(() {
        messages.add({"sender": "bot", "text": replies.first});
        _isLoading = false;
      });
      return;
    }

    try {
      List<ExpenseModel> expenses = await _expenseService.fetchExpenses();

      String contextData = _createSmartContext(expenses);

      final prompt = """
Sen Fida finans asistanısın.

$contextData

Kullanıcı sorusu:
$userText

Kurallar:
- Akıcı ve TAM cümleler kur
- Yarım cümle bırakma
- 2-3 cümle yaz
- Samimi ol
- Gerekirse analiz yap ve öneri ver
""";

      final response = await http
          .post(
            Uri.parse(
              "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey",
            ),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "contents": [
                {
                  "parts": [
                    {"text": prompt},
                  ],
                },
              ],
              "generationConfig": {
                "temperature": 0.7,
                "topP": 0.9,
                "maxOutputTokens": 1024,
              },
            }),
          )
          .timeout(const Duration(seconds: 20));

      final data = jsonDecode(response.body);

      print("API RESPONSE: $data");

      if (data["error"] != null) {
        setState(() {
          messages.add({
            "sender": "bot",
            "text": "API Hatası:\n${data["error"]["message"]}",
          });
        });
        return;
      }

      if (data["candidates"] == null || data["candidates"].isEmpty) {
        setState(() {
          messages.add({"sender": "bot", "text": "Cevap alınamadı ⚠️"});
        });
        return;
      }

      // 🔥 PARÇALI TEXT BİRLEŞTİR
      String botText = "";
      var parts = data["candidates"][0]["content"]["parts"];

      if (parts != null) {
        for (var p in parts) {
          if (p["text"] != null) {
            botText += p["text"];
          }
        }
      }

      if (botText.isEmpty) {
        botText = "Cevap oluşturulamadı";
      }

      // 🔥 cümle düzeltme
      if (!botText.trim().endsWith(".") &&
          !botText.trim().endsWith("!") &&
          !botText.trim().endsWith("?")) {
        botText += ".";
      }

      setState(() {
        messages.add({"sender": "bot", "text": botText});
      });
    } catch (e) {
      setState(() {
        messages.add({"sender": "bot", "text": "Hata oluştu:\n$e"});
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorDarkBlue,
      appBar: AppBar(
        title: const Text(
          "Fida Asistan",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: colorDarkBlue,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                bool isUser = messages[index]["sender"] == "user";

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isUser ? colorBordo : colorDarkBordo,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      messages[index]["text"]!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),

          if (_isLoading) const LinearProgressIndicator(color: colorBordo),

          Container(
            padding: const EdgeInsets.all(10),
            color: colorDarkBlue,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white12,
                      hintText: "Mesaj yaz...",
                      hintStyle: const TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: colorBordo),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
