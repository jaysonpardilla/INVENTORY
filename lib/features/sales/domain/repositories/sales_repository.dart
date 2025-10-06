import 'package:dartz/dartz.dart';
import '../../../../core/failures/failures.dart';

import '../entities/daily_sales.dart';
import '../entities/weekly_sales.dart';
import '../entities/monthly_sales.dart';
import '../entities/total_sales.dart';
import '../usecases/execute_sale_usecase.dart'; 

abstract class SalesRepository {
  Stream<List<DailySales>> streamDailySales(String ownerId);
  Stream<List<WeeklySales>> streamWeeklySales(String ownerId);
  Stream<List<MonthlySales>> streamMonthlySales(String ownerId);
  Stream<List<TotalSales>> streamTotalSales(String ownerId);

  Future<Either<Failure, void>> executeSaleTransaction(
      List<SaleItem> items, String ownerId);
}







