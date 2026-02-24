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
