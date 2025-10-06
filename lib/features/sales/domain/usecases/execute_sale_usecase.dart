import 'package:dartz/dartz.dart';
import '../../../../core/failures/failures.dart'; 
import '../../../products/domain/entities/product.dart';
import '../repositories/sales_repository.dart';

/// Helper class to bundle product and quantity for a sale item.
class SaleItem {
  final Product product;
  final int quantity;
  SaleItem({required this.product, required this.quantity});
}
class ExecuteSaleUsecase {
  final SalesRepository repository;
  ExecuteSaleUsecase(this.repository);

  Future<Either<Failure, void>> call(
      List<SaleItem> items, String ownerId) async {
    for (var item in items) {
      if (item.product.quantityInStock < item.quantity) {
        return Left(BusinessFailure(
            message: 'Insufficient stock for ${item.product.name}.'));
      }
    }
    return repository.executeSaleTransaction(items, ownerId);
  }
}
