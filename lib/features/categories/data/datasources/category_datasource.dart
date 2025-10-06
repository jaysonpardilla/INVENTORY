// lib/features/categories/data/datasources/category_datasource.dart
import '../../domain/entities/category.dart'; 

// 💡 Change to abstract class (the contract/interface)
abstract class CategoryDataSource {
  Stream<List<Category>> streamCategories(String ownerId);

  Future<Category?> getCategoryById(String id);

  Future<String> addCategory(Category category);

  Future<void> updateCategory(Category category);

  Future<void> deleteCategory(String id);
}