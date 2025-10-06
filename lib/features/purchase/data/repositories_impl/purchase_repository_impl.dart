import 'package:dartz/dartz.dart';
import '../../../../core/failures/failures.dart';
import '../../domain/repositories/purchase_repository.dart';
import '../datasources/purchase_datasource.dart';

/// Concrete implementation of [PurchaseRepository].
class PurchaseRepositoryImpl implements PurchaseRepository {
  final PurchaseDataSource dataSource;

  PurchaseRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, void>> createPurchaseTransaction({
    required String ownerId,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      await dataSource.createPurchaseTransaction(ownerId: ownerId, items: items);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
