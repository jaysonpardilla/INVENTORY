// inventory/lib/models/category.dart
class Category {
  String id;
  String name;
  String imageUrl;
  String ownerId;

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.ownerId,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'imageUrl': imageUrl,
        'ownerId': ownerId,
      };

  factory Category.fromMap(String id, Map<String, dynamic> map) {
    return Category(
      id: id,
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      ownerId: map['ownerId'] ?? '',
    );
  }
}
