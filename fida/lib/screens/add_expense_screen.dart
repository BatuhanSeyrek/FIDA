import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  static const colorBg = Color(0xFF14183e);
  static const colorPrimary = Color(0xFF9c1132);

  final List<Map<String, dynamic>> categories = [
    {
      "name": "Yemek",
      "icon": Icons.fastfood_rounded,
      "enum": "BESLENME_VE_GIDA",
    },
    {"name": "Ulaşım", "icon": Icons.commute_rounded, "enum": "ULASIM_VE_ARAC"},
    {
      "name": "Market",
      "icon": Icons.shopping_basket_rounded,
      "enum": "BESLENME_VE_GIDA",
    },
    {
      "name": "Eğlence",
      "icon": Icons.sports_esports_rounded,
      "enum": "EGLENCE_VE_SOSYALLESME",
    },
    {
      "name": "Fatura",
      "icon": Icons.payments_rounded,
      "enum": "FATURALAR_VE_ABONELIKLER",
    },
    {
      "name": "Kıyafet",
      "icon": Icons.checkroom_rounded,
      "enum": "GIYIM_VE_AKSESUAR",
    },
    {"name": "Diğer", "icon": Icons.grid_view_rounded, "enum": "DIGER"},
  ];

  String? selectedCategory;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (selectedCategory == null || amountController.text.trim().isEmpty) {
      _showSnack("Lütfen zorunlu alanları doldurun", true);
      return;
    }

    final provider = Provider.of<ExpenseProvider>(context, listen: false);

    // HATA ÇÖZÜMÜ: firstWhere içindeki elemanları açıkça String olarak cast ediyoruz
    final categoryData = categories.firstWhere(
      (cat) => (cat["name"] as String) == selectedCategory,
      orElse: () => categories.last,
    );

    String enumType = categoryData["enum"] as String;
    double amount = double.tryParse(amountController.text) ?? 0.0;
    String details =
        noteController.text.trim().isEmpty
            ? selectedCategory!
            : noteController.text.trim();

    bool success = await provider.addExpense(amount, details, enumType);

    if (success && mounted) {
      _showSnack("Harcama kaydedildi", false);
      // HATA ÇÖZÜMÜ: Navigator stack hatasını önlemek için güvenli pop
      if (Navigator.of(context).canPop()) {
        Navigator.pop(context);
      } else {
        setState(() {
          selectedCategory = null;
          amountController.clear();
          noteController.clear();
        });
      }
    }
  }

  void _showSnack(String msg, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: isError ? colorPrimary : Colors.teal.shade900,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 100),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBg,
      body: Stack(
        children: [
          // 1. ANA ARKA PLAN (Derin Radyal Gradyan)
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.6, -0.7),
                radius: 1.3,
                colors: [Color(0xFF1E2452), colorBg],
              ),
            ),
          ),

          // 2. MESH EFEKTİ - Sağ Üst Işıma
          Positioned(
            top: -150,
            right: -100,
            child: Container(
              width: 450,
              height: 450,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorPrimary.withOpacity(0.08),
              ),
            ),
          ),

          // 3. MESH EFEKTİ - Sol Alt Işıma
          Positioned(
            bottom: -80,
            left: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorPrimary.withOpacity(0.04),
              ),
            ),
          ),

          // 4. İÇERİK KATMANI
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  _buildHeaderWallet(),
                  const SizedBox(height: 25),
                  const Text(
                    "YENİ İŞLEM",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 6,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 40),

                  _buildModernInput(
                    label: "TUTAR",
                    child: TextField(
                      controller: amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        hintText: "0.00",
                        hintStyle: TextStyle(color: Colors.white10),
                        suffixText: " ₺",
                        suffixStyle: TextStyle(
                          color: colorPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  _buildModernInput(
                    label: "KATEGORİ",
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: const Color(0xFF1A1D42),
                        value: selectedCategory,
                        isExpanded: true,
                        hint: const Text(
                          "Seçim Yapın",
                          style: TextStyle(color: Colors.white24, fontSize: 15),
                        ),
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: colorPrimary,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        items:
                            categories.map((cat) {
                              return DropdownMenuItem<String>(
                                value: cat["name"] as String, // Safe Casting
                                child: Row(
                                  children: [
                                    Icon(
                                      cat["icon"] as IconData,
                                      color: colorPrimary,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 15),
                                    Text(
                                      cat["name"] as String,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                        onChanged: (v) => setState(() => selectedCategory = v),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  _buildModernInput(
                    label: "AÇIKLAMA",
                    child: TextField(
                      controller: noteController,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      decoration: const InputDecoration(
                        hintText: "Opsiyonel not...",
                        hintStyle: TextStyle(color: Colors.white10),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),
                  _buildPrimaryButton(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderWallet() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.02),
        border: Border.all(color: colorPrimary.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: colorPrimary.withOpacity(0.15),
            blurRadius: 35,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Icon(
        Icons.account_balance_wallet_rounded,
        color: Colors.white,
        size: 42,
      ),
    );
  }

  Widget _buildModernInput({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 10),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.06),
              width: 1.2,
            ),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildPrimaryButton() {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: provider.isLoading ? null : _handleSave,
          child: Container(
            height: 65,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [colorPrimary, Color(0xFFBD163F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: colorPrimary.withOpacity(0.35),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child:
                  provider.isLoading
                      ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                      : const Text(
                        "İŞLEMİ ONAYLA",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                          fontSize: 15,
                        ),
                      ),
            ),
          ),
        );
      },
    );
  }
}
