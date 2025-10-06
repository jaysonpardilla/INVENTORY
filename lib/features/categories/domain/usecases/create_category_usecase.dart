// lib/features/categories/domain/usecases/create_category_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/failures/failures.dart';
import '../../domain/entities/category.dart';
import '../repositories/category_repository.dart';

class CreateCategoryUsecase {
  final CategoryRepository repository;

  CreateCategoryUsecase(this.repository);
  
  Future<Either<Failure, String>> call(Category category) {
    return repository.createCategory(category);
  }
}