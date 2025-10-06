// inventory/lib/models/daily_sales.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class DailySales {
  final String id;
  final DateTime date;
  final double salesAmount;
  final String ownerId;

  DailySales({
    required this.id,
    required this.date,
    required this.salesAmount,
    required this.ownerId,
  });

  factory DailySales.fromMap(String id, Map<String, dynamic> map) {
    DateTime parsedDate;

    if (map['date'] is Timestamp) {
      parsedDate = (map['date'] as Timestamp).toDate();
    } else if (map['date'] is String) {
      parsedDate = DateTime.tryParse(map['date']) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    return DailySales(
      id: id,
      date: parsedDate,
      salesAmount: (map['salesAmount'] ?? 0).toDouble(),
      ownerId: map['ownerId'] ?? '',
    );
  }
}
