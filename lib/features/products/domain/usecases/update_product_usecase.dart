// lib/features/products/domain/usecases/update_product_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/failures/failures.dart';
import '../../domain/entities/product.dart';
import '../repositories/product_repository.dart';

class UpdateProductUsecase {
  final ProductRepository repository;

  UpdateProductUsecase(this.repository);

  Future<Either<Failure, void>> call(Product product) {
    return repository.updateProduct(product);
  }
}