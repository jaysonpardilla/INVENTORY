import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../categories/domain/entities/category.dart';
import '../datasources/category_datasource.dart'; 
import '../../../../core/config.dart';

class CategoryDataSourceImpl implements CategoryDataSource {
  final FirebaseFirestore _db;

  CategoryDataSourceImpl(this._db);

  @override
  Stream<List<Category>> streamCategories(String ownerId) {
    return _db
      .collection(Config.categoriesCollection)
      .where('ownerId', isEqualTo: ownerId)
      .snapshots()
      .map((snap) =>
        snap.docs.map((d) => Category.fromMap(d.id, d.data())).toList());
    }

  @override
  Future<String> addCategory(Category category) async {
    final doc = _db.collection(Config.categoriesCollection).doc();
    await doc.set(category.toMap());
    return doc.id;
  }

  @override
  Future<void> updateCategory(Category category) async {
    await _db
    .collection(Config.categoriesCollection)
    .doc(category.id)
    .update(category.toMap());
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _db.collection(Config.categoriesCollection).doc(id).delete();
  }
  
  @override
  Future<Category?> getCategoryById(String id) async {
    final doc = await _db.collection(Config.categoriesCollection).doc(id).get();
    return doc.exists ? Category.fromMap(doc.id, doc.data()!) : null;
  }
}