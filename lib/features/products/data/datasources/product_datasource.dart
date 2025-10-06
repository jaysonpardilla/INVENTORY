// lib/features/products/data/datasources/product_datasource.dart (CORRECTED)
import 'package:uuid/uuid.dart';
import '../../domain/entities/product.dart';

abstract class ProductDataSource {
  Uuid get uuid;

  // 🔹 Products Stream (Read) - ABSTRACT SIGNATURE
  Stream<List<Product>> streamProducts(String userId);

  // 🔹 Add Product (Create) - ABSTRACT SIGNATURE
  Future<String> addProduct(Product product);

  // 🔹 Update Product (Update) - ABSTRACT SIGNATURE
  Future<void> updateProduct(Product product);

  // 🔹 Delete Product (Delete) - ABSTRACT SIGNATURE
  Future<void> deleteProduct(String id);

  // 💡 New method for the Stock Alert Usecase - ABSTRACT SIGNATURE
  Stream<List<Product>> streamLowStockProducts(String ownerId);

  // 💡 New method for the Add Quantity Usecase (explicit stock update) - ABSTRACT SIGNATURE
  Future<void> updateProductStock(String id, int newQuantity);
}