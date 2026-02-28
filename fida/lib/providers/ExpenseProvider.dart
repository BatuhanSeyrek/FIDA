import 'package:flutter/material.dart';
import '../models/ExpenseModel.dart';
import '../services/expense_service.dart';

class ExpenseeProvider with ChangeNotifier {
  final ExpenseService _service = ExpenseService();
  List<ExpenseModel> _expenses = [];
  bool _isLoading = false;

  List<ExpenseModel> get expenses => _expenses;
  bool get isLoading => _isLoading;

  Future<void> loadExpenses() async {
    _isLoading = true;
    notifyListeners();

    _expenses = await _service.fetchExpenses();

    _isLoading = false;
    notifyListeners();
  }

  // --- PROVIDER İÇİNE EKLENECEK KISIM ---
  List<double> get last30DaysTotals {
    List<double> dailyTotals = List.generate(30, (index) => 0.0);
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    for (var expense in _expenses) {
      DateTime expDate = DateTime(
        expense.createdAt.year,
        expense.createdAt.month,
        expense.createdAt.day,
      );
      int diff = today.difference(expDate).inDays;
      if (diff >= 0 && diff < 30) {
        dailyTotals[29 - diff] += expense.amount;
      }
    }
    return dailyTotals;
  }

  List<String> get last30DaysLabels {
    List<String> labels = [];
    DateTime now = DateTime.now();
    for (int i = 29; i >= 0; i--) {
      DateTime date = now.subtract(Duration(days: i));
      labels.add("${date.day} ${_getMonthName(date.month)}");
    }
    return labels;
  }

  String _getMonthName(int month) {
    const months = [
      "Oca",
      "Şub",
      "Mar",
      "Nis",
      "May",
      "Haz",
      "Tem",
      "Ağu",
      "Eyl",
      "Eki",
      "Kas",
      "Ara",
    ];
    return months[month - 1];
  }

  List<double> get monthlyTotals {
    // 12 aylık (0-11 index) boş bir liste oluştur
    List<double> totals = List.generate(12, (index) => 0.0);

    for (var expense in _expenses) {
      // createdAt içindeki ay bilgisini al (1-12 arası gelir, index için 1 çıkarılır)
      int monthIndex = expense.createdAt.month - 1;
      if (monthIndex >= 0 && monthIndex < 12) {
        totals[monthIndex] += expense.amount;
      }
    }
    return totals;
  }

  double get totalAmount => _expenses.fold(0, (sum, item) => sum + item.amount);

  get monthlyExpenses => null;
}
