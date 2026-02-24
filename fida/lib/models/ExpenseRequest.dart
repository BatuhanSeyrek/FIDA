import 'dart:convert';

class ExpenseRequest {
  final double amount;
  final String details;
  final String type; // Enum değerleri String olarak gidecek

  ExpenseRequest({
    required this.amount,
    required this.details,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "details": details,
    "type": type,
  };
}
