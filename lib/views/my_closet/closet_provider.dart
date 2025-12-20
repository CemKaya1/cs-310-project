import 'package:cs_310_project/models/item_doc_model.dart';
import 'package:flutter/material.dart';
import 'package:cs_310_project/services/database_service.dart';

class ClosetProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();

  // Returns a Stream of List<ItemDoc> from Firestore
  Stream<List<ItemDoc>> get itemsStream => _db.getItemsStream();

  // Delete an item from Firestore
  Future<void> deleteItem(String itemId) async {
    try {
      await _db.deleteItem(itemId);
      // No need to notifyListeners() manually because the Stream 
      // in MyClosetPage will automatically detect the deletion.
    } catch (e) {
      debugPrint("Error deleting item: $e");
      rethrow;
    }
  }

  // Update item details in Firestore
  Future<void> updateItem(String itemId, Map<String, dynamic> data) async {
    try {
      await _db.updateItem(itemId, data);
    } catch (e) {
      debugPrint("Error updating item: $e");
      rethrow;
    }
  }
}