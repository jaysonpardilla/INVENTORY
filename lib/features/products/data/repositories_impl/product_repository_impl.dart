// lib/features/products/data/repositories_impl/product_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../../../core/failures/failures.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/entities/product.dart';
import '../datasources/product_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductDataSource dataSource;

  ProductRepositoryImpl(this.dataSource);

  @override
  Stream<List<Product>> streamProducts(String ownerId) {
    return dataSource.streamProducts(ownerId);
  }

  @override
  Stream<List<Product>> streamLowStockProducts(String ownerId) {
    return dataSource.streamLowStockProducts(ownerId);
  }
  
  @override
  Future<Either<Failure, String>> createProduct(Product product) async {
    try {
      final id = await dataSource.addProduct(product);
      return Right(id);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(Product product) async {
    try {
      await dataSource.updateProduct(product);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProductStock(
      String id, int newQuantity) async {
    try {
      // In a real-world app, ProductDataSource should have a specific method
      // like `updateProductStockOnly`. For now, we assume the Data Source 
      // can handle this request based on the ID and new quantity.
      await dataSource.updateProductStock(id, newQuantity);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    try {
      await dataSource.deleteProduct(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}