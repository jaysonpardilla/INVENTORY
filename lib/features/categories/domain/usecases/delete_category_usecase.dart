// lib/features/categories/domain/usecases/delete_category_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/failures/failures.dart';
import '../repositories/category_repository.dart';

class DeleteCategoryUsecase {
  final CategoryRepository repository;

  DeleteCategoryUsecase(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteCategory(id);
  }
}