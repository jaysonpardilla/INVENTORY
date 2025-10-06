import '../../domain/repositories/transaction_repository.dart';
import '../../domain/entities/transaction.dart';
import '../datasources/transaction_datasource.dart';

/// Concrete implementation of the [TransactionRepository] contract.
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionDataSource dataSource;

  TransactionRepositoryImpl(this.dataSource);

  @override
  Stream<List<InventoryTransaction>> streamTransactions(String ownerId) {
    return dataSource.streamTransactions(ownerId);
  }
}
