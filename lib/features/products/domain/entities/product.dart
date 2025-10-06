// inventory/lib/models/product.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id;
  String name;
  double price;
  int quantityInStock;
  String supplierId;
  String categoryId;
  String imageUrl;
  int quantityBuyPerItem;
  String ownerId;
  final int stockAlertLevel; 


  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantityInStock,
    required this.supplierId,
    required this.categoryId,
    this.imageUrl = '',
    this.quantityBuyPerItem = 0,
    required this.ownerId, 
    this.stockAlertLevel = 10, // Default to 10 if not specified

  });

  // 🔹 Implementation of copyWith to allow immutable updates
  Product copyWith({
    String? id,
    String? name,
    double? price,
    int? quantityInStock,
    String? supplierId,
    String? categoryId,
    String? imageUrl,
    int? quantityBuyPerItem,
    String? ownerId,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantityInStock: quantityInStock ?? this.quantityInStock,
      supplierId: supplierId ?? this.supplierId,
      categoryId: categoryId ?? this.categoryId,
      imageUrl: imageUrl ?? this.imageUrl,
      quantityBuyPerItem: quantityBuyPerItem ?? this.quantityBuyPerItem,
      ownerId: ownerId ?? this.ownerId, 
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'price': price,
        'quantityInStock': quantityInStock,
        'supplierId': supplierId,
        'categoryId': categoryId,
        'imageUrl': imageUrl,
        'quantityBuyPerItem': quantityBuyPerItem,
        'ownerId': ownerId,
        'stockAlertLevel': stockAlertLevel, 

      };

  factory Product.fromMap(String id, Map<String, dynamic> map) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quantityInStock: (map['quantityInStock'] ?? 0).toInt(),
      supplierId: map['supplierId'] ?? '',
      categoryId: map['categoryId'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      quantityBuyPerItem: (map['quantityBuyPerItem'] ?? 0).toInt(),
      ownerId: map['ownerId'] ?? '', 
      stockAlertLevel: map['stockAlertLevel'] as int? ?? 10, 
    );
  }

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product.fromMap(doc.id, data);
  }

}
