// lib/features/products/data/datasources/product_datasource_impl.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/config.dart';
import '../../domain/entities/product.dart';
import '../datasources/product_datasource.dart'; 

class ProductDataSourceImpl implements ProductDataSource {
  final FirebaseFirestore _db;
  final Uuid _uuid = const Uuid();
  ProductDataSourceImpl(this._db);

  @override
  Uuid get uuid => _uuid;

  @override
  Stream<List<Product>> streamProducts(String userId) {
    return _db
    .collection(Config.productsCollection)
    .where('ownerId', isEqualTo: userId)
    .snapshots()
    .map((snap) =>
    snap.docs.map((d) => Product.fromMap(d.id, d.data())).toList());
  }

  @override
  Future<String> addProduct(Product product) async {
    final doc = _db.collection(Config.productsCollection).doc();
    await doc.set(product.toMap()); 
    return doc.id;
  }

  @override
  Future<void> updateProduct(Product product) async {
    await _db
    .collection(Config.productsCollection)
    .doc(product.id)
    .update(product.toMap());
  }

  @override
  Future<void> deleteProduct(String id) async {
    await _db.collection(Config.productsCollection).doc(id).delete();
  }

  @override
  Stream<List<Product>> streamLowStockProducts(String ownerId) {
    return _db
    .collection(Config.productsCollection)
    .where('ownerId', isEqualTo: ownerId)
    .snapshots()
    .map((snap) => snap.docs
    .map((d) => Product.fromMap(d.id, d.data()))
    .where((product) => (product.quantityInStock) < (product.stockAlertLevel))
    .toList());
  }

  @override
  Future<void> updateProductStock(String id, int newQuantity) async {
  await _db.collection(Config.productsCollection).doc(id).update({
    'quantityInStock': newQuantity,
  });
  }
}