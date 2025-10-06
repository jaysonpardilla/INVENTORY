import '../entities/daily_sales.dart';
import '../repositories/sales_repository.dart';

class StreamDailySalesUsecase {
  final SalesRepository _repository;
  StreamDailySalesUsecase(this._repository);
  Stream<List<DailySales>> call(String ownerId) {
    return _repository.streamDailySales(ownerId);
  }
}