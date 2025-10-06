// lib/features/categories/domain/usecases/update_category_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/failures/failures.dart';
import '../../domain/entities/category.dart';
import '../repositories/category_repository.dart';

class UpdateCategoryUsecase {
  final CategoryRepository repository;

  UpdateCategoryUsecase(this.repository);

  Future<Either<Failure, void>> call(Category category) {
    return repository.updateCategory(category);
  }
}










