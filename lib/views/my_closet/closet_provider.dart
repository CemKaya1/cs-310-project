import 'package:cs_310_project/models/item_doc_model.dart';
import 'package:flutter/material.dart';
import 'package:cs_310_project/services/database_service.dart';

/// Manages the state and business logic for the user's closet items.
/// Communicates directly with [DatabaseService] to reflect changes in Firestore.
class ClosetProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();


  // Provides a real-time connection to the items collection.
  // UI components should use a StreamBuilder to listen to this getter.
  Stream<List<ItemDoc>> get itemsStream => _db.getItemsStream();

  /// Deletes a specific item by its document ID.
  Future<void> deleteItem(String itemId) async {
    try {
      await _db.deleteItem(itemId);
    } catch (e) {
      debugPrint("Error deleting item: $e");
      rethrow; // Pass error to the UI for snackbar/alert handling
    }
  }

  /// Updates specific fields of an existing item (e.g., color, category).
  Future<void> updateItem(String itemId, Map<String, dynamic> data) async {
    try {
      await _db.updateItem(itemId, data);
    } catch (e) {
      debugPrint("Error updating item: $e");
      rethrow;
    }
  }
}
