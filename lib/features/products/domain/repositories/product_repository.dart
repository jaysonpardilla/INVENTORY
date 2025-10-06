// lib/features/products/domain/repositories/product_repository.dart
import '../../../../core/failures/failures.dart';
import 'package:dartz/dartz.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  // Returns a stream of all products for the owner
  Stream<List<Product>> streamProducts(String ownerId);

  // Creates a new product
  Future<Either<Failure, String>> createProduct(Product product);

  // Updates an existing product
  Future<Either<Failure, void>> updateProduct(Product product);

  // Deletes a product by ID
  Future<Either<Failure, void>> deleteProduct(String id);

  // Specific method for updating only the stock quantity
  Future<Either<Failure, void>> updateProductStock(String id, int newQuantity); 

   // 💡 This is the new method signature required by the Usecase.
  Stream<List<Product>> streamLowStockProducts(String ownerId);
}