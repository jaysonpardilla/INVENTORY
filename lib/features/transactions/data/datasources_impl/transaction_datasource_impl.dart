import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/config.dart';
import '../../domain/entities/transaction.dart';
import '../datasources/transaction_datasource.dart';

class TransactionDataSourceImpl implements TransactionDataSource {
  final FirebaseFirestore _db;
  final String _collection = Config.transactionsCollection;

  TransactionDataSourceImpl(this._db);

  @override
  Stream<List<InventoryTransaction>> streamTransactions(String ownerId) {
    return _db
    .collection(_collection)
    .where('ownerId', isEqualTo: ownerId)
    .orderBy('transactionDate', descending: true) 
    .snapshots()
    .map((snap) => snap.docs
    .map((d) => InventoryTransaction.fromMap(d.id, d.data()))
    .toList());
  }
}
