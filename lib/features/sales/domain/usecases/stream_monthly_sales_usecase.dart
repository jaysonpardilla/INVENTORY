import '../entities/monthly_sales.dart';
import '../repositories/sales_repository.dart';

class StreamMonthlySalesUsecase {
  final SalesRepository _repository;
  StreamMonthlySalesUsecase(this._repository);
  Stream<List<MonthlySales>> call(String ownerId) {
    return _repository.streamMonthlySales(ownerId);
  }
}