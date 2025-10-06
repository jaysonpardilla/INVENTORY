// inventory/lib/models/transaction.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryTransaction {
  final String id;
  final String productId;
  final String transactionType;
  final DateTime transactionDate;
  final double amount;
  final int quantity;
  final String ownerId;

  InventoryTransaction({
    required this.id,
    required this.productId,
    required this.transactionType,
    required this.transactionDate,
    required this.amount,
    required this.quantity,
    required this.ownerId,
  });

  factory InventoryTransaction.fromMap(String id, Map<String, dynamic> map) {
    DateTime parsedDate;

    if (map['transactionDate'] is Timestamp) {
      parsedDate = (map['transactionDate'] as Timestamp).toDate();
    } else if (map['transactionDate'] is String) {
      parsedDate = DateTime.tryParse(map['transactionDate']) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    return InventoryTransaction(
      id: id,
      productId: map['productId'] ?? '',
      transactionType: map['transactionType'] ?? '',
      transactionDate: parsedDate,
      amount: (map['amount'] ?? 0).toDouble(),
      quantity: (map['quantity'] ?? 0).toInt(),
      ownerId: map['ownerId'] ?? '',
    );
  }
}
