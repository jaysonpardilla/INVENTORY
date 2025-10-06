// inventory/lib/models/monthly_sales.dart
class MonthlySales {
  String id;
  int year;
  int month; 
  double salesAmount;
  String ownerId;

  MonthlySales({
    required this.id,
    required this.year,
    required this.month,
    required this.salesAmount,
    required this.ownerId,
  });

  Map<String, dynamic> toMap() => {
    'year': year,
    'month': month,
    'salesAmount': salesAmount,
    'ownerId': ownerId,
  };

  factory MonthlySales.fromMap(String id, Map<String, dynamic> map) {
    return MonthlySales(
      id: id,
      year: map['year'] ?? 0,
      month: map['month'] ?? 0,
      salesAmount: (map['salesAmount'] ?? 0).toDouble(),
      ownerId: map['ownerId'] ?? '',
    );
  }
}
