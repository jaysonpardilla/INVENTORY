import 'package:cloud_firestore/cloud_firestore.dart';
// Updated imports for all involved Entities
import '../../../products/domain/entities/product.dart';
import '../../../../core/config.dart';
import '../datasources/purchase_datasource.dart'; // Import interface

/// Concrete implementation of [PurchaseDataSource] handling atomic Firestore transactions.
class PurchaseDataSourceImpl implements PurchaseDataSource {
  final FirebaseFirestore _db;

  PurchaseDataSourceImpl(this._db);

  @override
  Future<void> createPurchaseTransaction({
    required String ownerId,
    required List<Map<String, dynamic>> items,
  }) async {
    // This transaction ensures atomicity: all changes succeed, or none do.
    await _db.runTransaction((tx) async {
      double totalPurchaseAmount = 0;
      final productSnaps = <String, Map<String, dynamic>>{};

      // 🔹 Step 1: READ all products first
      // All reads must happen before any writes in a transaction.
      for (final item in items) {
        final productId = item['productId'] as String;
        final productRef = _db.collection(Config.productsCollection).doc(productId);
        final prodSnap = await tx.get(productRef);

        if (!prodSnap.exists) {
          throw Exception('Product $productId does not exist.');
        }
        productSnaps[productId] = prodSnap.data()!;
      }

      // 🔹 Step 2: PROCESS products & WRITE updates
      for (final item in items) {
        final productId = item['productId'] as String;
        final quantity = item['quantity'] as int;

        final product = Product.fromMap(productId, productSnaps[productId]!);

        // The original logic checked for "Insufficient stock" which implies this
        // might be a *Sales* transaction, not a *Purchase* (stock *increase*).
        // Since the log uses 'Decrease stock' and checks stock, I'm assuming 
        // this is a *Sales* transaction (product is *sold*).
        // If this is truly a *Purchase* (buying from a supplier), the logic below
        // for stock and 'Decrease stock' transaction type must be reversed.
        
        // **ASSUMPTION:** Based on the user's provided code which DECREMENTS stock 
        // and checks for 'Insufficient stock', this method handles a **SALE**.
        
        if (product.quantityInStock < quantity) {
          throw Exception('Insufficient stock for ${product.name}');
        }

        // Calculate sale amount
        final double saleAmount = quantity * product.price;
        totalPurchaseAmount += saleAmount;

        final newQty = product.quantityInStock - quantity;
        
        // NOTE: 'quantityBuyPerItem' seems like a misnomer if it tracks sales. 
        // Reusing the original logic, but commenting for clarity.
        final newQuantityBuyPerItem = product.quantityBuyPerItem + quantity; 

        // 🔹 Update product stock (DECREMENT)
        final productRef = _db.collection(Config.productsCollection).doc(productId);
        tx.update(productRef, {
          'quantityInStock': newQty,
          // Assuming 'quantityBuyPerItem' tracks total units sold for now.
          'quantityBuyPerItem': newQuantityBuyPerItem, 
        });

        // 🔹 Add transaction record (TYPE: Decrease stock)
        final transRef = _db.collection(Config.transactionsCollection).doc();
        tx.set(transRef, {
          'productId': productId,
          'transactionType': 'Decrease stock', // Indicates a Sale
          'transactionDate': Timestamp.now(),
          'amount': saleAmount,
          'quantity': quantity,
          'ownerId': ownerId,
        });

        // 🔹 Update per-product Total Sales 
        final productTotalQuery = await _db
            .collection(Config.totalSalesCollection)
            .where('productId', isEqualTo: productId)
            .where('ownerId', isEqualTo: ownerId)
            .limit(1)
            .get();

        if (productTotalQuery.docs.isEmpty) {
          final doc = _db.collection(Config.totalSalesCollection).doc();
          tx.set(doc, {
            'productId': productId,
            'salesPerItem': saleAmount,
            'totalSales': saleAmount,
            'ownerId': ownerId,
          });
        } else {
          final docRef = productTotalQuery.docs.first.reference;
          final current = productTotalQuery.docs.first.data();
          final updatedSales =
              (current['salesPerItem'] as num? ?? 0).toDouble() + saleAmount;
          final updatedTotal =
              (current['totalSales'] as num? ?? 0).toDouble() + saleAmount;
          tx.update(docRef, {
            'salesPerItem': updatedSales,
            'totalSales': updatedTotal,
          });
        }
      }

      // 🔹 Step 3: Update Aggregated Sales (Daily, Weekly, Monthly, Overall)
      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);
      
      // Helper function for Week Number (re-used from user's provided logic)
      int weekNumber(DateTime date) {
        final firstDayOfYear = DateTime(date.year, 1, 1);
        final daysOffset = firstDayOfYear.weekday - 1;
        final firstMonday = firstDayOfYear.subtract(Duration(days: daysOffset));
        return ((date.difference(firstMonday).inDays) / 7).floor() + 1;
      }

      // --- DAILY ---
      final dailyQuery = await _db
          .collection(Config.dailySalesCollection)
          .where('ownerId', isEqualTo: ownerId)
          .where('date', isEqualTo: Timestamp.fromDate(todayDate))
          .limit(1)
          .get();

      if (dailyQuery.docs.isEmpty) {
        final doc = _db.collection(Config.dailySalesCollection).doc();
        tx.set(doc, {
          'date': Timestamp.fromDate(todayDate),
          'salesAmount': totalPurchaseAmount,
          'ownerId': ownerId,
        });
      } else {
        final docRef = dailyQuery.docs.first.reference;
        final current = dailyQuery.docs.first.data();
        final updated =
            (current['salesAmount'] as num? ?? 0).toDouble() + totalPurchaseAmount;
        tx.update(docRef, {'salesAmount': updated});
      }

      // --- WEEKLY ---
      final year = today.year;
      final week = weekNumber(today);
      final weeklyQuery = await _db
          .collection(Config.weeklySalesCollection) // Assuming config is set
          .where('ownerId', isEqualTo: ownerId)
          .where('year', isEqualTo: year)
          .where('weekNumber', isEqualTo: week)
          .limit(1)
          .get();

      if (weeklyQuery.docs.isEmpty) {
        final doc = _db.collection(Config.weeklySalesCollection).doc();
        tx.set(doc, {
          'year': year,
          'weekNumber': week,
          'salesAmount': totalPurchaseAmount,
          'ownerId': ownerId,
        });
      } else {
        final docRef = weeklyQuery.docs.first.reference;
        final current = weeklyQuery.docs.first.data();
        final updated =
            (current['salesAmount'] as num? ?? 0).toDouble() + totalPurchaseAmount;
        tx.update(docRef, {'salesAmount': updated});
      }

      // --- MONTHLY ---
      final month = today.month;
      final monthlyQuery = await _db
          .collection(Config.monthlySalesCollection) // Assuming config is set
          .where('ownerId', isEqualTo: ownerId)
          .where('year', isEqualTo: year)
          .where('month', isEqualTo: month)
          .limit(1)
          .get();

      if (monthlyQuery.docs.isEmpty) {
        final doc = _db.collection(Config.monthlySalesCollection).doc();
        tx.set(doc, {
          'year': year,
          'month': month,
          'salesAmount': totalPurchaseAmount,
          'ownerId': ownerId,
        });
      } else {
        final docRef = monthlyQuery.docs.first.reference;
        final current = monthlyQuery.docs.first.data();
        final updated =
            (current['salesAmount'] as num? ?? 0).toDouble() + totalPurchaseAmount;
        tx.update(docRef, {'salesAmount': updated});
      }

      // --- OVERALL TOTAL ---
      // This assumes Overall Total is tracked in totalSalesCollection with productId: null
      final overallQuery = await _db
          .collection(Config.totalSalesCollection)
          .where('productId', isNull: true)
          .where('ownerId', isEqualTo: ownerId)
          .limit(1)
          .get();

      if (overallQuery.docs.isEmpty) {
        final doc = _db.collection(Config.totalSalesCollection).doc();
        tx.set(doc, {
          'productId': null,
          'salesPerItem': 0,
          'totalSales': totalPurchaseAmount,
          'ownerId': ownerId,
        });
      } else {
        final docRef = overallQuery.docs.first.reference;
        final current = overallQuery.docs.first.data();
        final updated =
            (current['totalSales'] as num? ?? 0).toDouble() + totalPurchaseAmount;
        tx.update(docRef, {'totalSales': updated});
      }
    });
  }
}
