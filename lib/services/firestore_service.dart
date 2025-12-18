import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cs_310_project/models/planner_entry_model.dart';
import 'package:cs_310_project/models/outfit_model.dart';
import 'package:cs_310_project/core/mock/mock_items.dart';
import 'package:cs_310_project/core/mock/mock_outfits.dart';
import 'package:cs_310_project/models/item_model.dart';
import 'package:cs_310_project/services/storage_service.dart';


class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final StorageService _storage = StorageService();

  String? get currentUserId => _auth.currentUser?.uid;

  // --- PLANNER İŞLEMLERİ ---

  // Dolu günleri getir (Stream: Veri değişirse anlık günceller)
  Stream<List<PlannerEntry>> getPlannerEntriesStream() {
    if (currentUserId == null) return Stream.value([]);

    return _db
        .collection('users')
        .doc(currentUserId)
        .collection('planner')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs
            .map((doc) => PlannerEntry.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Planner'a Mock Outfit kaydet
  Future<void> savePlannerEntry(int index, Outfit outfit) async {
    if (currentUserId == null) return;

    // Her kutu için sabit bir ID kullanıyoruz (slot_0, slot_1 vb.)
    // Böylece aynı güne tekrar sürükler sen üzerine yazar (Update eder).
    final docId = 'slot_$index';

    await _db
        .collection('users')
        .doc(currentUserId)
        .collection('planner')
        .doc(docId)
        .set({
      'id': docId,
      'createdBy': currentUserId,
      'createdAt': FieldValue.serverTimestamp(),
      'gridIndex': index,
      'outfitId': outfit.id,
      'outfitName': outfit.name,
      'outfitImagePath': outfit.imagePath,
    });
  }

  // Planner'dan sil
  Future<void> removePlannerEntry(int index) async {
    if (currentUserId == null) return;

    final docId = 'slot_$index';

    await _db
        .collection('users')
        .doc(currentUserId)
        .collection('planner')
        .doc(docId)
        .delete();
  }

// --- OUTFITS İŞLEMLERİ ---

  Future<void> saveUserOutfit(Outfit outfit) async {
    if (currentUserId == null) return;

    await _db
        .collection('users')
        .doc(currentUserId)
        .collection('outfits')
        .add({
      'name': outfit.name,
      'imagePath': outfit.imagePath,
      'itemImagePaths': outfit.items.map((e) => e.imagePath).toList(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> hydrateMockOutfitsFromFirestore() async {
    if (currentUserId == null) return;

    final snapshot = await _db
        .collection('users')
        .doc(currentUserId)
        .collection('outfits')
        .orderBy('createdAt', descending: true)
        .get();

    for (final doc in snapshot.docs) {
      final data = doc.data();

      final String name = data['name'] ?? 'New Outfit';
      final String imagePath = data['imagePath'] ?? '';

      final List<String> itemPaths =
      List<String>.from(data['itemImagePaths'] ?? []);

      final items = MockItems.list
          .where((item) => itemPaths.contains(item.imagePath))
          .toList();

      final alreadyExists = MockOutfits.list.any(
            (o) => o.name == name && o.imagePath == imagePath,
      );
      if (alreadyExists) continue;

      MockOutfits.list.insert(
        0,
        Outfit(
          name: name,
          imagePath: imagePath,
          items: items,
        ),
      );
    }
  }

  // --- OUTFITS (REAL-TIME) ---

  Stream<List<Outfit>> getOutfitsStream() {
    if (currentUserId == null) return Stream.value([]);

    return _db
        .collection('users')
        .doc(currentUserId)
        .collection('outfits')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(_outfitFromDoc).toList());
  }

  Outfit _outfitFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    final String name = (data['name'] ?? 'New Outfit') as String;
    final String imagePath = (data['imagePath'] ?? '') as String;
    final String? imageStoragePath =
        (data['imageStoragePath'] as String?) ?? (data['imagePathStorage'] as String?);

    // For now, keep compatibility with existing schema that stored `itemImagePaths`.
    final List<String> itemPaths =
        List<String>.from(data['itemImagePaths'] ?? data['itemPaths'] ?? []);

    final items = MockItems.list.where((item) => itemPaths.contains(item.imagePath)).toList();

    return Outfit(
      id: doc.id,
      name: name,
      imagePath: imagePath,
      imageStoragePath: imageStoragePath,
      items: items,
    );
  }

  Future<DocumentReference<Map<String, dynamic>>> createOutfit({
    required Outfit outfit,
  }) async {
    final uid = currentUserId;
    if (uid == null) throw Exception('Not authenticated');

    final ref = _db.collection('users').doc(uid).collection('outfits').doc();
    await ref.set({
      'id': ref.id,
      'createdBy': uid,
      'createdAt': FieldValue.serverTimestamp(),
      'name': outfit.name,
      'imagePath': outfit.imagePath,
      'imageStoragePath': outfit.imageStoragePath,
      'itemImagePaths': outfit.items.map((e) => e.imagePath).toList(),
    });
    return ref;
  }

  Future<DocumentReference<Map<String, dynamic>>> createOutfitWithOptionalUpload({
    required String name,
    required List<ClosetItemModel> items,
    required String fallbackImagePath,
    String? localImageFilePath,
  }) async {
    final uid = currentUserId;
    if (uid == null) throw Exception('Not authenticated');

    final ref = _db.collection('users').doc(uid).collection('outfits').doc();

    String imagePath = fallbackImagePath;
    String? imageStoragePath;

    if (localImageFilePath != null && localImageFilePath.isNotEmpty) {
      final uploaded = await _storage.uploadOutfitImage(
        outfitId: ref.id,
        file: File(localImageFilePath),
      );
      imagePath = uploaded.downloadUrl;
      imageStoragePath = uploaded.fullPath;
    }

    await ref.set({
      'id': ref.id,
      'createdBy': uid,
      'createdAt': FieldValue.serverTimestamp(),
      'name': name,
      'imagePath': imagePath,
      'imageStoragePath': imageStoragePath,
      'itemImagePaths': items.map((e) => e.imagePath).toList(),
    });

    return ref;
  }

  Future<void> updateOutfitName({required String outfitId, required String name}) async {
    final uid = currentUserId;
    if (uid == null) throw Exception('Not authenticated');
    await _db.collection('users').doc(uid).collection('outfits').doc(outfitId).update({
      'name': name,
    });
  }

  Future<void> deleteOutfit({required String outfitId, String? imageStoragePath}) async {
    final uid = currentUserId;
    if (uid == null) throw Exception('Not authenticated');

    await _db.collection('users').doc(uid).collection('outfits').doc(outfitId).delete();

    if (imageStoragePath != null && imageStoragePath.isNotEmpty) {
      try {
        await _storage.deleteByFullPath(imageStoragePath);
      } catch (_) {
        // ignore storage delete failures (e.g., missing object) to keep UX smooth
      }
    }
  }
}
