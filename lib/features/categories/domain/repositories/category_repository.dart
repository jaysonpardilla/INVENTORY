// lib/features/categories/domain/repositories/category_repository.dart
import '../../../../core/failures/failures.dart'; // Assuming you will add a custom Failure class
import 'package:dartz/dartz.dart'; // Assuming you use dartz for functional error handling
import '../entities/category.dart';

abstract class CategoryRepository {
  // Returns a stream of all categories for the owner
  Stream<List<Category>> streamCategories(String ownerId);

  // Creates a new category
  Future<Either<Failure, String>> createCategory(Category category);

  // Updates an existing category
  Future<Either<Failure, void>> updateCategory(Category category);

  // Deletes a category by ID
  Future<Either<Failure, void>> deleteCategory(String id);
}