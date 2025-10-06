// lib/features/stock_alert/data/datasources/stock_alert_datasource_impl.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../datasources/stock_alert_datasource.dart'; 
import '../../../products/domain/entities/product.dart'; 

class StockAlertDataSourceImpl implements StockAlertDataSource {
  final FirebaseFirestore _db; 
  StockAlertDataSourceImpl(this._db);

  @override
  Stream<List<Product>> streamAllProductsForAlert(String userId) {
    return _db
      .collection('products')
      .where('ownerId', isEqualTo: userId)
      .snapshots()
      .map((snapshot) {
      return snapshot.docs
      .map((doc) => Product.fromFirestore(doc))
      .where((p) => p.quantityInStock < 10) 
      .toList();
    });
    }
}