// lib/features/products/domain/usecases/update_product_stock_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/failures/failures.dart';
import '../repositories/product_repository.dart';

class UpdateProductStockUsecase {
  final ProductRepository repository;

  UpdateProductStockUsecase(this.repository);
  Future<Either<Failure, void>> call({
    required String productId,
    required int quantityChange, 
    required int currentStock,
  }) async {
  if (currentStock + quantityChange < 0) {
    return const Left(AuthFailure(message: 'Cannot reduce stock below zero.'));
  }
  final newQuantity = currentStock + quantityChange;
  
  return repository.updateProductStock(productId, newQuantity);
  }
}