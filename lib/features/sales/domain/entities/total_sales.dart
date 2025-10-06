// inventory/lib/models/total_sales.dart
class TotalSales {
  String id;
  String? productId;
  double salesPerItem;
  double totalSales;
  String ownerId;

  TotalSales({
    required this.id,
    this.productId,
    this.salesPerItem = 0,
    this.totalSales = 0,
    required this.ownerId,
  });

  Map<String, dynamic> toMap() => {
        'productId': productId,
        'salesPerItem': salesPerItem,
        'totalSales': totalSales,
        'ownerId': ownerId,
      };

  factory TotalSales.fromMap(String id, Map<String, dynamic> map) {
    return TotalSales(
      id: id,
      productId: map['productId'],
      salesPerItem: (map['salesPerItem'] ?? 0).toDouble(),
      totalSales: (map['totalSales'] ?? 0).toDouble(),
      ownerId: map['ownerId'] ?? '',
    );
  }
}
