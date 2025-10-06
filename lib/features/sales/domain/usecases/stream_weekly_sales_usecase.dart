import '../entities/weekly_sales.dart';
import '../repositories/sales_repository.dart';

class StreamWeeklySalesUsecase {
  final SalesRepository _repository;
  StreamWeeklySalesUsecase(this._repository);
  Stream<List<WeeklySales>> call(String ownerId) {
    return _repository.streamWeeklySales(ownerId);
  }
}