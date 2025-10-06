import 'package:dartz/dartz.dart';
import '../../../../core/failures/failures.dart';
import '../../domain/repositories/sales_repository.dart';
import '../../domain/entities/daily_sales.dart';
import '../../domain/entities/weekly_sales.dart';
import '../../domain/entities/monthly_sales.dart';
import '../../domain/entities/total_sales.dart';
import '../datasources/sales_datasource.dart';
import '../../domain/usecases/execute_sale_usecase.dart'; 

/// Concrete implementation of [SalesRepository].
class SalesRepositoryImpl implements SalesRepository {
  final SalesDataSource dataSource;

  SalesRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, void>> executeSaleTransaction(
      List<SaleItem> items, String ownerId) async {
    try {
      await dataSource.executeSaleTransaction(items, ownerId);
      return const Right(null);
    } catch (e) {
      // Catch any exceptions (e.g., database error) and map to a failure.
      return Left(ServerFailure(message: 'Sale transaction failed: ${e.toString()}'));
    }
  }

  @override
  Stream<List<DailySales>> streamDailySales(String ownerId) =>
      dataSource.streamDailySales(ownerId);

  @override
  Stream<List<WeeklySales>> streamWeeklySales(String ownerId) =>
      dataSource.streamWeeklySales(ownerId);

  @override
  Stream<List<MonthlySales>> streamMonthlySales(String ownerId) =>
      dataSource.streamMonthlySales(ownerId);

  @override
  Stream<List<TotalSales>> streamTotalSales(String ownerId) =>
      dataSource.streamTotalSales(ownerId);
}
