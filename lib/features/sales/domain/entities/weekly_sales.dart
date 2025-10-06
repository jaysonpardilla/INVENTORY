// inventory/lib/models/weekly_sales.dart
class WeeklySales {
  String id;
  int year;
  int weekNumber;
  double salesAmount;
  String ownerId;

  WeeklySales({
    required this.id,
    required this.year,
    required this.weekNumber,
    required this.salesAmount,
    required this.ownerId,
  });

  Map<String, dynamic> toMap() => {
        'year': year,
        'weekNumber': weekNumber,
        'salesAmount': salesAmount,
        'ownerId': ownerId,
      };

  factory WeeklySales.fromMap(String id, Map<String, dynamic> map) {
    return WeeklySales(
      id: id,
      year: map['year'] ?? 0,
      weekNumber: map['weekNumber'] ?? 0,
      salesAmount: (map['salesAmount'] ?? 0).toDouble(),
      ownerId: map['ownerId'] ?? '',
    );
  }
}
