// lib/features/categories/domain/usecases/stream_categories_usecase.dart
import '../../domain/entities/category.dart';
import '../repositories/category_repository.dart';

class StreamCategoriesUsecase {
  final CategoryRepository repository;

  StreamCategoriesUsecase(this.repository);

  Stream<List<Category>> call(String ownerId) {
    return repository.streamCategories(ownerId);
  }
}