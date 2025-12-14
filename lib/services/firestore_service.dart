import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cs_310_project/models/planner_entry_model.dart';
import 'package:cs_310_project/models/outfit_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
        .map((snapshot) => snapshot.docs
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
      'gridIndex': index,
      'outfitName': outfit.name, // Mock datadan ismi alıp kaydediyoruz
      'outfitImagePath': outfit.imagePath, // Mock datadan resmi alıp kaydediyoruz
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
}