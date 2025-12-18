import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cs_310_project/core/mock/mock_items.dart';
import 'package:cs_310_project/core/mock/mock_outfits.dart';

/// Seeds mock items/outfits into Firestore for the current user
/// if their collections are empty. Runs per-login.
class MockSeedService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> _itemsCol(String uid) =>
      _db.collection('users').doc(uid).collection('items');

  CollectionReference<Map<String, dynamic>> _outfitsCol(String uid) =>
      _db.collection('users').doc(uid).collection('outfits');

  Future<void> seedIfEmpty() async {
    final uid = _uid;
    if (uid == null) return;

    await _seedItemsIfEmpty(uid);
    await _seedOutfitsIfEmpty(uid);
  }

  Future<void> _seedItemsIfEmpty(String uid) async {
    final col = _itemsCol(uid);
    final snap = await col.limit(1).get();
    if (snap.docs.isNotEmpty) return;

    final batch = _db.batch();
    for (final item in MockItems.list) {
      final ref = col.doc();
      batch.set(ref, {
        'id': ref.id,
        'createdBy': uid,
        'createdAt': FieldValue.serverTimestamp(),
        'name': item.name,
        'category': item.category,
        'style': item.style,
        'season': item.season,
        'color': item.color,
        'imageUrl': item.imagePath, // asset path
        'imagePath': null,
      });
    }
    await batch.commit();
  }

  Future<void> _seedOutfitsIfEmpty(String uid) async {
    final col = _outfitsCol(uid);
    final snap = await col.limit(1).get();
    if (snap.docs.isNotEmpty) return;

    final batch = _db.batch();
    for (final outfit in MockOutfits.list) {
      final ref = col.doc();
      batch.set(ref, {
        'id': ref.id,
        'createdBy': uid,
        'createdAt': FieldValue.serverTimestamp(),
        'name': outfit.name,
        'imagePath': outfit.imagePath, // asset path
        'imageStoragePath': null,
        'itemImagePaths': outfit.items.map((e) => e.imagePath).toList(),
      });
    }
    await batch.commit();
  }
}
