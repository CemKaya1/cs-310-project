import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs_310_project/models/item_doc_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Make sure this import points to where you defined ItemDoc. 
// If it's in a different file, adjust the import.

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> _itemsCol(String uid) =>
      _db.collection('users').doc(uid).collection('items');

  DocumentReference<Map<String, dynamic>> newItemRef() {
    final uid = currentUserId;
    if (uid == null) throw Exception('Not authenticated');
    return _itemsCol(uid).doc();
  }

  Future<void> setItem(DocumentReference<Map<String, dynamic>> ref, Map<String, dynamic> data) async {
    final uid = currentUserId;
    if (uid == null) throw Exception('Not authenticated');

    final now = FieldValue.serverTimestamp();
    final payload = {
      'id': ref.id,
      'createdBy': uid,
      'createdAt': now,
      ...data,
    };

    await ref.set(payload);
  }

  // --- NEW METHODS FOR CLOSET & DETAIL PAGE ---

  /// Stream to get all items for the current user in real-time
  Stream<List<ItemDoc>> getItemsStream() {
    final uid = currentUserId;
    if (uid == null) return Stream.value([]);

    return _itemsCol(uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ItemDoc.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  /// Delete an item by ID
  Future<void> deleteItem(String itemId) async {
    final uid = currentUserId;
    if (uid == null) throw Exception('Not authenticated');
    
    await _itemsCol(uid).doc(itemId).delete();
  }

  /// Update specific fields of an item
  Future<void> updateItem(String itemId, Map<String, dynamic> data) async {
    final uid = currentUserId;
    if (uid == null) throw Exception('Not authenticated');

    await _itemsCol(uid).doc(itemId).update(data);
  }
}