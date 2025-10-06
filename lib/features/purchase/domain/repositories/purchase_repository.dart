import '../../../../core/failures/failures.dart';
import 'package:dartz/dartz.dart';

abstract class PurchaseRepository {
  Future<Either<Failure, void>> createPurchaseTransaction({
    required String ownerId,
    required List<Map<String, dynamic>> items,
  });
}

