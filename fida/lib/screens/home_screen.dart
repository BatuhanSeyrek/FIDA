import 'package:fida/providers/ExpenseProvider.dart';
import 'package:fida/providers/IncomeProvider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const colorDarkBlue = Color(0xFF14183e);
  static const colorPrimary = Color(0xFF9c1132);

  @override
  void initState() {
    super.initState();
    // Sayfa yüklendiğinde verileri çek
    Future.microtask(() {
      context.read<ExpenseeProvider>().loadExpenses();
      context.read<IncomeProvider>().loadIncome();
    });
  }

  // GELİR GÜNCELLEME POP-UP (DIALOG)
  void _showIncomeUpdateDialog(BuildContext context, double currentVal) {
    final TextEditingController _controller = TextEditingController(
      text: currentVal > 0 ? currentVal.toStringAsFixed(0) : "",
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF1e2452),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: const Text(
              "Geliri Güncelle",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Mevcut gelir kaydınız silinecek ve yeni miktar kaydedilecektir.",
                  style: TextStyle(color: Colors.white54, fontSize: 13),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                  decoration: InputDecoration(
                    prefixText: "₺ ",
                    prefixStyle: const TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 20,
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: colorPrimary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "İptal",
                  style: TextStyle(color: Colors.white54),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final val = double.tryParse(_controller.text);
                  if (val != null) {
                    // Provider üzerinden Silme + Kaydetme işlemi
                    await context.read<IncomeProvider>().saveNewIncome(val);
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  "Güncelle",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = context.watch<ExpenseeProvider>();
    final incomeProvider = context.watch<IncomeProvider>();

    return Scaffold(
      backgroundColor: colorDarkBlue,
      body: Stack(
        children: [
          // Arka Plan Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.5, -0.6),
                radius: 1.2,
                colors: [Color(0xFF1E2452), colorDarkBlue],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 30),
                  // Bakiyeyi (Gelir - Gider) olarak gösteren kart
                  _buildBalanceCard(
                    expenseProvider.totalAmount,
                    incomeProvider.incomeAmount,
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Tıklanabilir Gelir Kartı
                      GestureDetector(
                        onTap:
                            () => _showIncomeUpdateDialog(
                              context,
                              incomeProvider.incomeAmount,
                            ),
                        child: _miniCard(
                          "Gelir",
                          "₺ ${incomeProvider.incomeAmount.toStringAsFixed(0)}",
                          Colors.greenAccent,
                          isEditable: true,
                        ),
                      ),
                      // Gider Kartı
                      _miniCard(
                        "Gider",
                        "₺ ${expenseProvider.totalAmount.toStringAsFixed(0)}",
                        colorPrimary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  _sectionHeader("30 GÜNLÜK HARCAMA ANALİZİ"),
                  const SizedBox(height: 20),
                  _buildDailyChart(expenseProvider),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          // Backend işlemi sırasında yükleniyor göstergesi
          if (incomeProvider.isLoading)
            Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(color: colorPrimary),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hoş Geldin,",
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
            Text(
              "Fida Finans",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        CircleAvatar(
          backgroundColor: colorPrimary,
          radius: 22,
          child: Icon(Icons.person, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildBalanceCard(double totalExpense, double currentIncome) {
    double currentBalance = currentIncome - totalExpense;
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
            color: colorPrimary.withOpacity(0.35),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Kullanılabilir Bakiye",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "₺ ${currentBalance.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniCard(
    String title,
    String amount,
    Color accentColor, {
    bool isEditable = false,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.42,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 3.5, backgroundColor: accentColor),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
              if (isEditable)
                const Icon(Icons.edit_note, color: Colors.white24, size: 18),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyChart(ExpenseeProvider provider) {
    List<double> chartData = provider.last30DaysTotals;
    List<String> labels = provider.last30DaysLabels;

    double maxVal =
        chartData.isEmpty ? 1000 : chartData.reduce((a, b) => a > b ? a : b);
    if (maxVal == 0) maxVal = 1000;

    return Container(
      height: 270,
      padding: const EdgeInsets.fromLTRB(5, 25, 20, 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.025),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 29,
          minY: 0,
          maxY: maxVal * 1.3,
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              // tooltipBgColor yerine getTooltipColor kullanıldı (fl_chart v0.60+ hatasını çözer)
              getTooltipColor: (spot) => colorDarkBlue.withOpacity(0.9),
              getTooltipItems:
                  (spots) =>
                      spots
                          .map(
                            (s) => LineTooltipItem(
                              "${labels[s.x.toInt()]}\n₺${s.y.toStringAsFixed(0)}",
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                          .toList(),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            verticalInterval: 7,
            getDrawingHorizontalLine:
                (value) => FlLine(
                  color: Colors.white.withOpacity(0.02),
                  strokeWidth: 1,
                ),
            getDrawingVerticalLine:
                (value) => FlLine(
                  color: Colors.white.withOpacity(0.02),
                  strokeWidth: 1,
                ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                interval: 6,
                getTitlesWidget: (value, meta) {
                  int i = value.toInt();
                  if (i >= 0 && i < labels.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        labels[i],
                        style: TextStyle(
                          color:
                              i == 29
                                  ? colorPrimary
                                  : Colors.white.withOpacity(0.2),
                          fontSize: 9,
                          fontWeight:
                              i == 29 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots:
                  chartData
                      .asMap()
                      .entries
                      .map((e) => FlSpot(e.key.toDouble(), e.value))
                      .toList(),
              isCurved: true,
              curveSmoothness: 0.35,
              color: colorPrimary,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                checkToShowDot: (spot, barData) => spot.x == 29,
                getDotPainter:
                    (spot, p, bar, i) => FlDotCirclePainter(
                      radius: 4,
                      color: colorPrimary,
                      strokeColor: Colors.white,
                      strokeWidth: 2,
                    ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorPrimary.withOpacity(0.2),
                    colorPrimary.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white.withOpacity(0.35),
        fontSize: 10,
        fontWeight: FontWeight.w900,
        letterSpacing: 2,
      ),
    );
  }
}
