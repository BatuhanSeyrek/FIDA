import 'package:fida/models/ExpenseRequest.dart';
import 'package:flutter/material.dart';
import '../services/expense_service.dart';

class ExpenseProvider with ChangeNotifier {
  final ExpenseService _service = ExpenseService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> addExpense(double amount, String details, String type) async {
    _isLoading = true;
    notifyListeners();

    final request = ExpenseRequest(
      amount: amount,
      details: details,
      type: type,
    );
    bool success = await _service.recordExpense(request);

    _isLoading = false;
    notifyListeners();
    return success;
  }
}
