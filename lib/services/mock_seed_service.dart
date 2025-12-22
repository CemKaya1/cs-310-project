import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cs_310_project/models/item_model.dart';

/// Seeds mock items/outfits into Firestore for the current user
/// if their collections are empty. Runs per-login.
class MockSeedService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  // Static seed data (do not use runtime MockItems.list / MockOutfits.list).
  static final List<ClosetItemModel> _seedItems = [
    ClosetItemModel(
      name: "Black T-Shirt",
      category: "Top",
      style: "Casual",
      season: "Summer",
      color: "Black",
      imagePath: "lib/core/mock/mock_images/black_tshirt.jpg",
    ),
    ClosetItemModel(
      name: "Blue T-Shirt",
      category: "Top",
      style: "Casual",
      season: "Summer",
      color: "Blue",
      imagePath: "lib/core/mock/mock_images/blue_tshirt.jpg",
    ),
    ClosetItemModel(
      name: "Black Jeans",
      category: "Bottom",
      style: "Classic",
      season: "All",
      color: "Black",
      imagePath: "lib/core/mock/mock_images/black_jean.jpg",
    ),
    ClosetItemModel(
      name: "Blue Jeans",
      category: "Bottom",
      style: "Classic",
      season: "All",
      color: "Blue",
      imagePath: "lib/core/mock/mock_images/blue_jean.jpg",
    ),
  ];

  static final List<({String name, List<ClosetItemModel> items, String imagePath})> _seedOutfits = [
    (
      name: "Casual Blue",
      items: [_seedItems[1], _seedItems[3]],
      imagePath: "lib/core/mock/mock_images/blue_tshirt.jpg"
    ),
    (
      name: "Street Black",
      items: [_seedItems[0], _seedItems[2]],
      imagePath: "lib/core/mock/mock_images/black_tshirt.jpg"
    ),
  ];

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
    for (final item in _seedItems) {
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
    for (final outfit in _seedOutfits) {
      final ref = col.doc();
      batch.set(ref, {
        'id': ref.id,
        'createdBy': uid,
        'createdAt': FieldValue.serverTimestamp(),
        'name': outfit.name,
        'imagePath': outfit.imagePath, // asset path
        'imageStoragePath': null,
        'itemImagePaths': outfit.items.map((e) => e.imagePath).toList(),
        'items': outfit.items.map((e) {
          return {
            'name': e.name,
            'category': e.category,
            'style': e.style,
            'season': e.season,
            'color': e.color,
            'imagePath': e.imagePath,
          };
        }).toList(),
      });
    }
    await batch.commit();
  }
}
