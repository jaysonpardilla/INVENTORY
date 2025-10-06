// lib/features/categories/data/repositories_impl/category_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../../../core/failures/failures.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/entities/category.dart';
import '../datasources/category_datasource.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDataSource dataSource;

  CategoryRepositoryImpl(this.dataSource);

  @override
  Stream<List<Category>> streamCategories(String ownerId) {
    return dataSource.streamCategories(ownerId);
  }

  @override
  Future<Either<Failure, String>> createCategory(Category category) async {
    try {
      final id = await dataSource.addCategory(category);
      return Right(id);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateCategory(Category category) async {
    try {
      await dataSource.updateCategory(category);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String id) async {
    try {
      await dataSource.deleteCategory(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}