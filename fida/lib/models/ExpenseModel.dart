class ExpenseModel {
  final double amount;
  final String details;
  final String type;
  final DateTime createdAt;
  final int userId;

  ExpenseModel({
    required this.amount,
    required this.details,
    required this.type,
    required this.createdAt,
    required this.userId,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      // amount bazen int bazen double gelebilir, risk almamak için toDouble()
      amount: (json['amount'] as num).toDouble(),
      details: json['details'] ?? '',
      type: json['type'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      userId: json['user_id'] ?? 0,
    );
  }
}
