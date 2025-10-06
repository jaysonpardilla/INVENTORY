// lib/features/stock_alert/domain/repositories/stock_alert_repository.dart
import '../../../products/domain/entities/product.dart'; 

abstract class StockAlertRepository {
  Stream<List<Product>> streamLowStockProducts(String ownerId);
}




