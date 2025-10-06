
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_app/features/sales/domain/usecases/execute_sale_usecase.dart';
import 'sales_datasource.dart'; // Import the abstract class
import '../../../../core/config.dart';
import '../../domain/entities/daily_sales.dart';
import '../../domain/entities/weekly_sales.dart';
import '../../domain/entities/monthly_sales.dart';
import '../../domain/entities/total_sales.dart';

// ✅ This is the CONCRETE implementation
class FirebaseSalesDataSource implements SalesDataSource {
  // Move the Firebase instance here
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 🔹 Daily Sales Stream
  @override
  Stream<List<DailySales>> streamDailySales(String ownerId) {
    return _db
        .collection(Config.dailySalesCollection)
        .where('ownerId', isEqualTo: ownerId)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => DailySales.fromMap(d.id, d.data())).toList());
  }
  
  // 🔹 Weekly Sales Stream
  @override
  Stream<List<WeeklySales>> streamWeeklySales(String ownerId) {
    return _db
        .collection(Config.weeklySalesCollection)
        .where('ownerId', isEqualTo: ownerId)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => WeeklySales.fromMap(d.id, d.data())).toList());
  }
  
  // 🔹 Monthly Sales Stream
  @override
  Stream<List<MonthlySales>> streamMonthlySales(String ownerId) {
    return _db
        .collection(Config.monthlySalesCollection)
        .where('ownerId', isEqualTo: ownerId)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => MonthlySales.fromMap(d.id, d.data())).toList());
  }
  
  // 🔹 Total Sales Stream
  @override
  Stream<List<TotalSales>> streamTotalSales(String ownerId) {
    return _db
        .collection(Config.totalSalesCollection)
        .where('ownerId', isEqualTo: ownerId)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => TotalSales.fromMap(d.id, d.data())).toList());
  }

  // 💡 Implement the abstract method
  @override
  Future<void> executeSaleTransaction(List<SaleItem> items, String ownerId) async {
    // NOTE: This is where your actual complex Firebase transaction logic will go
    // For now, use an empty or placeholder implementation to resolve the compile error.
    print('Executing sale transaction for $ownerId with ${items.length} items.');
    // Example: await _db.runTransaction((transaction) async { ... });
  }
}