import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<DocumentReference> addItem(Map<String, dynamic> data) async {
    if (currentUserId == null) throw Exception('Not authenticated');

    final ref = _db
        .collection('users')
        .doc(currentUserId)
        .collection('items')
        .doc();

    final now = FieldValue.serverTimestamp();

    final payload = {
      'id': ref.id,
      'createdBy': currentUserId,
      'createdAt': now,
      ...data,
    };

    await ref.set(payload);
    return ref;
  }
}
