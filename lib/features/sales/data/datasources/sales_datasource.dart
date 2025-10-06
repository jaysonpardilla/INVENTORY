import '../../domain/entities/daily_sales.dart';
import '../../domain/entities/weekly_sales.dart';
import '../../domain/entities/monthly_sales.dart';
import '../../domain/entities/total_sales.dart';
import '../../domain/usecases/execute_sale_usecase.dart';

abstract class SalesDataSource {
  Future<void> executeSaleTransaction(List<SaleItem> items, String ownerId);

  Stream<List<DailySales>> streamDailySales(String ownerId);
  Stream<List<WeeklySales>> streamWeeklySales(String ownerId);
  Stream<List<MonthlySales>> streamMonthlySales(String ownerId);
  Stream<List<TotalSales>> streamTotalSales(String ownerId);
}
