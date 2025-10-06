import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:uuid/uuid.dart';

import '../../../../core/config.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../domain/entities/daily_sales.dart';
import '../../domain/entities/monthly_sales.dart';
import '../../domain/entities/weekly_sales.dart';
import '../../domain/entities/total_sales.dart';
import '../../domain/usecases/execute_sale_usecase.dart';
import '../datasources/sales_datasource.dart';

/// Concrete implementation of [SalesDataSource] using Firebase Firestore.
/// Uses a Batch Write for atomic sale execution.
class SalesDataSourceImpl implements SalesDataSource {
  final FirebaseFirestore _db;
 // final Uuid _uuid = const Uuid();

  SalesDataSourceImpl(this._db);

  /// Executes the core sale transaction using an atomic batch write.
  /// Assumes stock validation has already passed at the Use Case layer.
  @override
  Future<void> executeSaleTransaction(
      List<SaleItem> items, String ownerId) async {
    final now = DateTime.now();
    final batch = _db.batch();
    
    // Use fixed date keys for easy lookup and merging
    final dailyDocId = ownerId + '_${now.year}-${now.month}-${now.day}';
    final monthlyDocId = ownerId + '_${now.year}-${now.month}';

    double totalSaleAmount = 0.0;

    for (var item in items) {
      final product = item.product;
      final qtySold = item.quantity;
      final salePrice = product.price;
      final itemTotal = salePrice * qtySold;

      totalSaleAmount += itemTotal;

      // 1. Update Product Stock (Decrease quantity)
      final productRef = _db.collection(Config.productsCollection).doc(product.id);
      batch.update(productRef, {
        'quantityInStock': FieldValue.increment(-qtySold),
      });

      // 2. Create InventoryTransaction Record
      final transactionRef = _db.collection(Config.transactionsCollection).doc();
      final transaction = InventoryTransaction(
        id: transactionRef.id,
        productId: product.id,
        transactionType: 'SALE',
        transactionDate: now,
        amount: itemTotal,
        quantity: qtySold,
        ownerId: ownerId,
      );
      batch.set(transactionRef, transaction.toMap());
      
      // 3. Update Per-Product Total Sales (can use the config collection here)
      final productTotalRef = _db.collection(Config.totalSalesCollection)
          .doc('${ownerId}_${product.id}');
      
      batch.set(productTotalRef, {
        'productId': product.id,
        'salesPerItem': FieldValue.increment(itemTotal),
        'totalSales': FieldValue.increment(itemTotal), // Incrementing both for simplicity
        'ownerId': ownerId,
      }, SetOptions(merge: true));
    }
    
    // 4. Update Daily Sales Aggregate
    final dailyRef = _db.collection(Config.dailySalesCollection).doc(dailyDocId);
    batch.set(dailyRef, {
      'salesAmount': FieldValue.increment(totalSaleAmount),
      'date': Timestamp.fromDate(DateTime(now.year, now.month, now.day)),
      'ownerId': ownerId,
    }, SetOptions(merge: true));
    
    // 5. Update Monthly Sales Aggregate
    final monthlyRef = _db.collection(Config.monthlySalesCollection).doc(monthlyDocId);
    batch.set(monthlyRef, {
      'salesAmount': FieldValue.increment(totalSaleAmount),
      'year': now.year,
      'month': now.month,
      'ownerId': ownerId,
    }, SetOptions(merge: true));
    
    // 6. Update Overall Total Sales (Assuming a single document for overall total per user)
    final overallTotalRef = _db.collection(Config.totalSalesCollection).doc(ownerId);
    batch.set(overallTotalRef, {
      'productId': null, // Marker for overall total
      'totalSales': FieldValue.increment(totalSaleAmount),
      'ownerId': ownerId,
    }, SetOptions(merge: true));


    // Commit all operations atomically
    await batch.commit();
  }

  // --- Streams for Dashboard Metrics ---

  @override
  Stream<List<DailySales>> streamDailySales(String ownerId) {
    return _db
        .collection(Config.dailySalesCollection)
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => DailySales.fromMap(d.id, d.data())).toList());
  }

  @override
  Stream<List<WeeklySales>> streamWeeklySales(String ownerId) {
    return _db
        .collection(Config.weeklySalesCollection)
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('weekNumber', descending: true) 
        .snapshots()
        .map((snap) => 
            snap.docs.map((d) => WeeklySales.fromMap(d.id, d.data())).toList()); 
  }

  @override
  Stream<List<MonthlySales>> streamMonthlySales(String ownerId) {
    return _db
        .collection(Config.monthlySalesCollection)
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('year', descending: true)
        .orderBy('month', descending: true) 
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => MonthlySales.fromMap(d.id, d.data())).toList());
  }
  
  @override
  Stream<List<TotalSales>> streamTotalSales(String ownerId) {
    return _db
        .collection(Config.totalSalesCollection)
        .where('ownerId', isEqualTo: ownerId)
        // Filter out per-product totals to only get the main aggregated totals if needed
        .where('productId', isNull: true) 
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => TotalSales.fromMap(d.id, d.data()))
            .toList());
  }
}
