import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const colorDarkBlue = Color(0xFF14183e);
    const colorBordo = Color(0xFF9c1132);
    const colorDarkBordo = Color(0xFF821034);

    return Scaffold(
      backgroundColor: colorDarkBlue,
      appBar: AppBar(
        backgroundColor: colorDarkBlue,
        elevation: 0,
        title: const Text("Fida Finans", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOPLAM BAKİYE
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: colorBordo,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Toplam Bakiye",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "₺ 42,580",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ALT KARTLAR
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _miniCard("Gelir", "₺ 12,400", Colors.greenAccent),
                  _miniCard("Gider", "₺ 5,900", Colors.redAccent),
                ],
              ),

              const SizedBox(height: 40),

              const Text(
                "Aylık Finans Grafiği",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(height: 20),

              // GRAFİK
              Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Color(0xFF1f234f),
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: const EdgeInsets.all(15),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 1),
                          FlSpot(1, 1.8),
                          FlSpot(2, 1.4),
                          FlSpot(3, 2.5),
                          FlSpot(4, 3.2),
                          FlSpot(5, 2.8),
                          FlSpot(6, 4),
                        ],
                        isCurved: true,
                        color: colorBordo,
                        barWidth: 4,
                        dotData: FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Mini istatistik kartı
  Widget _miniCard(String title, String amount, Color barColor) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1f234f),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 10),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
