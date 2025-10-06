import 'package:dartz/dartz.dart';
import '../../../../core/failures/failures.dart';
import '../repositories/purchase_repository.dart';

class CreatePurchaseTransactionUsecase {
  final PurchaseRepository repository;
  CreatePurchaseTransactionUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required String ownerId,
    required List<Map<String, dynamic>> items,
  }) async {
    return await repository.createPurchaseTransaction(
      ownerId: ownerId,
      items: items,
    );
  }
}
