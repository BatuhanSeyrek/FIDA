import 'package:fida/providers/ExpenseProvider.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  static const colorBg = Color(0xFF14183e);
  static const colorPrimary = Color(0xFF9c1132); // İkonların ana vurgu rengi
  static const colorCardBg = Color(0xFF1b2255);

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ExpenseeProvider>().loadExpenses());
  }

  // --- KATEGORİ YARDIMCI METODU ---
  // Renkleri senin istediğin gibi 'colorPrimary' (Fatura rengi) üzerine kurguladım
  Map<String, dynamic> _getCategoryDetails(String type) {
    switch (type) {
      case "BESLENME_VE_GIDA":
        return {"name": "Yemek & Market", "icon": Icons.restaurant};
      case "BARINMA_VE_EV_GIDERLERI":
        return {"name": "Ev Giderleri", "icon": Icons.home_work_rounded};
      case "FATURALAR_VE_ABONELIKLER":
        return {
          "name": "Fatura & Abonelik",
          "icon": Icons.receipt_long_rounded,
        };
      case "ULASIM_VE_ARAC":
        return {"name": "Ulaşım & Araç", "icon": Icons.directions_bus_rounded};
      case "SAGLIK_VE_KISISEL_BAKIM":
        return {
          "name": "Sağlık & Bakım",
          "icon": Icons.medical_services_rounded,
        };
      case "EGLENCE_VE_SOSYALLESME":
        return {"name": "Eğlence & Sosyal", "icon": Icons.celebration_rounded};
      case "EGITIM_VE_GELISIM":
        return {"name": "Eğitim", "icon": Icons.school_rounded};
      case "GIYIM_VE_AKSESUAR":
        return {"name": "Giyim & Aksesuar", "icon": Icons.checkroom_rounded};
      case "YATIRIM_VE_TASARRUF":
        return {"name": "Yatırım & Tasarruf", "icon": Icons.savings_rounded};
      case "BORC_VE_TAKSIT_ODEMELERI":
        return {"name": "Borç & Taksit", "icon": Icons.credit_card_rounded};
      case "HEDIYE_VE_BAGIS":
        return {"name": "Hediye & Bağış", "icon": Icons.redeem_rounded};
      case "COCUK_VE_EVCIL_HAYVAN":
        return {"name": "Çocuk & Evcil", "icon": Icons.pets_rounded};
      case "VERGI_VE_SIGORTA":
        return {
          "name": "Vergi & Sigorta",
          "icon": Icons.assured_workload_rounded,
        };
      case "DIGER":
      default:
        return {"name": "Diğer", "icon": Icons.category_rounded};
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseeProvider>();

    return Scaffold(
      backgroundColor: colorBg,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.5, -0.6),
                radius: 1.2,
                colors: [Color(0xFF1E2452), colorBg],
              ),
            ),
          ),
          SafeArea(
            child:
                provider.isLoading && provider.expenses.isEmpty
                    ? const Center(
                      child: CircularProgressIndicator(color: colorPrimary),
                    )
                    : RefreshIndicator(
                      onRefresh: () => provider.loadExpenses(),
                      backgroundColor: colorCardBg,
                      color: colorPrimary,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            _buildCustomAppBar(),
                            const SizedBox(height: 30),
                            _toplamBakiyeCard(provider.totalAmount),
                            const SizedBox(height: 35),
                            _sectionHeader("AYLIK ÖZET"),
                            const SizedBox(height: 15),
                            _miniGrafik(provider.monthlyTotals),
                            const SizedBox(height: 35),
                            _sectionHeader("SON İŞLEMLER"),
                            const SizedBox(height: 15),
                            _islemListesi(provider),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return const Center(
      child: Text(
        "HESABIM",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          letterSpacing: 6,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _toplamBakiyeCard(double total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [colorPrimary, Color(0xFF821034)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: colorPrimary.withOpacity(0.3),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "TOPLAM GİDER",
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "${total.toStringAsFixed(2)} ₺",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 38,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniGrafik(List<double> monthlyData) {
    double maxVal =
        monthlyData.isEmpty ? 100 : monthlyData.reduce((a, b) => a > b ? a : b);
    if (maxVal == 0) maxVal = 100;

    return Container(
      height: 200,
      padding: const EdgeInsets.fromLTRB(15, 25, 15, 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxVal * 1.3,
          barGroups: List.generate(monthlyData.length, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: monthlyData[index],
                  width: 14,
                  color: colorPrimary,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(5),
                  ),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxVal * 1.3,
                    color: Colors.white.withOpacity(0.02),
                  ),
                ),
              ],
            );
          }),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const months = [
                    'O',
                    'Ş',
                    'M',
                    'N',
                    'M',
                    'H',
                    'T',
                    'A',
                    'E',
                    'E',
                    'K',
                    'A',
                  ];
                  return Text(
                    months[value.toInt()],
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.2),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
        ),
      ),
    );
  }

  Widget _islemListesi(ExpenseeProvider provider) {
    if (provider.expenses.isEmpty) {
      return Center(
        child: Text(
          "Harcama bulunamadı.",
          style: TextStyle(color: Colors.white.withOpacity(0.2)),
        ),
      );
    }

    var sortedList =
        provider.expenses.toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedList.length,
      itemBuilder: (context, index) {
        final expense = sortedList[index];
        final category = _getCategoryDetails(expense.type);

        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            children: [
              // İKON KUTUCUĞU - İstediğin Vurgulu Renk
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorPrimary.withOpacity(
                    0.15,
                  ), // Arka planda yumuşak vurgu
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  category["icon"],
                  color: colorPrimary, // İkonun kendisi tam parlak vurgu
                  size: 22,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.details,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category["name"],
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.3),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "-${expense.amount.toStringAsFixed(2)} ₺",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('dd.MM').format(expense.createdAt),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.2),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white.withOpacity(0.4),
        fontSize: 11,
        fontWeight: FontWeight.w900,
        letterSpacing: 2,
      ),
    );
  }
}
