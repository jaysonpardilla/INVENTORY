// lib/features/transactions/domain/repositories/transaction_repository.dart
import '../entities/transaction.dart';

abstract class TransactionRepository {
  // Returns a stream of all transaction records (history)
  Stream<List<InventoryTransaction>> streamTransactions(String ownerId);
}