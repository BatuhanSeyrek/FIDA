import 'package:flutter/material.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  static const colorDarkBlue = Color(0xFF14183e);
  static const colorBordo = Color(0xFF9c1132);
  static const colorDarkBordo = Color(0xFF821034);

  final List<String> categories = [
    "Yemek",
    "Ulaşım",
    "Market",
    "Eğlence",
    "Fatura",
    "Kıyafet",
    "Diğer",
  ];

  String? selectedCategory;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorDarkBlue,
      appBar: AppBar(
        backgroundColor: colorDarkBlue,
        elevation: 0,
        title: const Text(
          "Harcama Ekle",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kategori Alanı
            const Text(
              "Kategori",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: colorDarkBlue.withOpacity(0.5),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colorBordo, width: 1.2),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: colorDarkBlue,
                  value: selectedCategory,
                  isExpanded: true,
                  hint: const Text(
                    "Kategori Seç",
                    style: TextStyle(color: Colors.white70),
                  ),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  items:
                      categories.map((cat) {
                        return DropdownMenuItem(
                          value: cat,
                          child: Text(
                            cat,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() => selectedCategory = value);
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Tutar Bölümü
            const Text(
              "Tutar (₺)",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: colorDarkBlue.withOpacity(0.5),
                hintText: "Örn: 250",
                hintStyle: const TextStyle(color: Colors.white54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: colorBordo),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: colorDarkBordo, width: 1.5),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Not Alanı
            const Text(
              "Not (Opsiyonel)",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: noteController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: colorDarkBlue.withOpacity(0.5),
                hintText: "Harcama ile ilgili kısa not",
                hintStyle: const TextStyle(color: Colors.white54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: colorBordo),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Kaydet Butonu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedCategory == null ||
                      amountController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Lütfen kategori ve tutar girin"),
                      ),
                    );
                    return;
                  }

                  // BACKENDE GÖNDERMEYİ BURAYA KOYACAKSIN
                  print("Kategori: $selectedCategory");
                  print("Tutar: ${amountController.text}");
                  print("Not: ${noteController.text}");

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorBordo,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Kaydet",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
