import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({super.key});

  // Renk paletin
  static const colorDarkBlue = Color(0xFF14183e);
  static const colorBordo = Color(0xFF9c1132);
  static const colorDarkBordo = Color(0xFF821034);

  final List<Map<String, dynamic>> hesaplar = [
    {"isim": "Nakit", "bakiye": 850.0, "icon": Icons.payments},
    {"isim": "Banka Kartı", "bakiye": 4560.0, "icon": Icons.credit_card},
    {"isim": "Kredi Kartı", "bakiye": -1200.0, "icon": Icons.credit_card_off},
  ];

  final List<Map<String, dynamic>> islemler = [
    {"kategori": "Market", "tutar": 120, "icon": Icons.shopping_cart},
    {"kategori": "Yemek", "tutar": 85, "icon": Icons.fastfood},
    {"kategori": "Ulaşım", "tutar": 48, "icon": Icons.directions_bus},
    {"kategori": "Fatura", "tutar": 430, "icon": Icons.receipt},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorDarkBlue,
      appBar: AppBar(
        backgroundColor: colorDarkBlue,
        elevation: 0,
        title: const Text(
          "Hesabım",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //------------------ TOPLAM BAKİYE ------------------
            _toplamBakiyeCard(),

            const SizedBox(height: 20),

            //------------------ HESAPLARIM ------------------
            const Text(
              "Hesaplarım",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _hesapListesi(),

            const SizedBox(height: 25),

            //------------------ AYLIK HARCAMA GRAFİĞİ ------------------
            const Text(
              "Aylık Harcama Özeti",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _miniGrafik(),

            const SizedBox(height: 25),

            //------------------ İŞLEM GEÇMİŞİ ------------------
            const Text(
              "Son İşlemler",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _islemListesi(),
          ],
        ),
      ),
    );
  }

  // ------------------ WIDGETS ------------------

  Widget _toplamBakiyeCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: colorDarkBordo,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 12),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Toplam Bakiye",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            "5.250 ₺",
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _hesapListesi() {
    return Column(
      children:
          hesaplar.map((hesap) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF1b2255),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Icon(hesap["icon"], color: Colors.white, size: 28),
                  const SizedBox(width: 15),
                  Text(
                    hesap["isim"],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "${hesap["bakiye"]} ₺",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _miniGrafik() {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1b2255),
        borderRadius: BorderRadius.circular(15),
      ),
      child: BarChart(
        BarChartData(
          barGroups: [_bar(0, 4), _bar(1, 6), _bar(2, 3), _bar(3, 5)],
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
        ),
      ),
    );
  }

  BarChartGroupData _bar(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 18,
          color: colorBordo,
          borderRadius: BorderRadius.circular(6),
        ),
      ],
    );
  }

  Widget _islemListesi() {
    return Column(
      children:
          islemler.map((islem) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF1b2255),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Icon(islem["icon"], color: Colors.white, size: 26),
                  const SizedBox(width: 15),
                  Text(
                    islem["kategori"],
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const Spacer(),
                  Text(
                    "-${islem["tutar"]} ₺",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }
}
