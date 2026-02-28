class IncomeModel {
  final int? id;
  final double income;

  IncomeModel({this.id, required this.income});

  // JSON'dan Model'e (Listeleme için)
  factory IncomeModel.fromJson(Map<String, dynamic> json) {
    return IncomeModel(
      id: json['id'],
      // BigDecimal bazen String bazen double gelebilir, güvenli dönüşüm:
      income: double.parse(json['income'].toString()),
    );
  }

  // Model'den JSON'a (Kayıt için)
  Map<String, dynamic> toJson() {
    return {
      'income': income,
      // 'user' alanı backend'de HttpServletRequest üzerinden set edildiği için
      // burada göndermemize gerek yok.
    };
  }
}
