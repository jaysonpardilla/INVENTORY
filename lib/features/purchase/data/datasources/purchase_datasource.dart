
abstract class PurchaseDataSource {
  Future<void> createPurchaseTransaction({
    required String ownerId,
    required List<Map<String, dynamic>> items,
  });
}
