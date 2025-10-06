import '../../domain/entities/transaction.dart'; 

abstract class TransactionDataSource {
  Stream<List<InventoryTransaction>> streamTransactions(String ownerId);
}
