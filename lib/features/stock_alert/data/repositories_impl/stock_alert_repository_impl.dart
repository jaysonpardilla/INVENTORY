// lib/features/stock_alert/data/repositories_impl/stock_alert_repository_impl.dart

import '../../domain/repositories/stock_alert_repository.dart';
import '../../../products/domain/entities/product.dart'; 
import '../datasources/stock_alert_datasource.dart';

class StockAlertRepositoryImpl implements StockAlertRepository {
final StockAlertDataSource dataSource; 

StockAlertRepositoryImpl(this.dataSource);

@override
Stream<List<Product>> streamLowStockProducts(String ownerId) {
 return dataSource.streamAllProductsForAlert(ownerId);
 }
}