// lib/features/transactions/domain/usecases/stream_transactions_usecase.dart
import '../../domain/entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class StreamTransactionsUsecase {
  final TransactionRepository repository;
  StreamTransactionsUsecase(this.repository);
  
  Stream<List<InventoryTransaction>> call(String ownerId) {
    return repository.streamTransactions(ownerId);
  }
}