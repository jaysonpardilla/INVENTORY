// lib/features/stock_alert/data/datasources/stock_alert_datasource.dart

import 'package:inventory_app/features/products/domain/entities/product.dart';

abstract class StockAlertDataSource {

Stream<List<Product>> streamAllProductsForAlert(String userId);
} 
