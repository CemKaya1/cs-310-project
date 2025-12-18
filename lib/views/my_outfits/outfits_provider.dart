import 'package:flutter/material.dart';
import 'package:cs_310_project/models/outfit_model.dart';
import 'package:cs_310_project/services/firestore_service.dart';
import 'package:cs_310_project/models/item_model.dart';

class OutfitsProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();

  Stream<List<Outfit>> get outfitsStream => _service.getOutfitsStream();

  Future<void> hydrateMockOutfitsFromFirestore() async {
    await _service.hydrateMockOutfitsFromFirestore();
    notifyListeners();
  }

  Future<void> addOutfit(Outfit outfit) async {
    await _service.saveUserOutfit(outfit);
    notifyListeners();
  }

  Future<String> createOutfit({
    required String name,
    required List<ClosetItemModel> items,
    required String fallbackImagePath,
    String? localImageFilePath,
  }) async {
    final ref = await _service.createOutfitWithOptionalUpload(
      name: name,
      items: items,
      fallbackImagePath: fallbackImagePath,
      localImageFilePath: localImageFilePath,
    );
    notifyListeners();
    return ref.id;
  }

  Future<void> updateOutfitName({required String outfitId, required String name}) async {
    await _service.updateOutfitName(outfitId: outfitId, name: name);
    notifyListeners();
  }

  Future<void> deleteOutfit({required String outfitId, String? imageStoragePath}) async {
    await _service.deleteOutfit(outfitId: outfitId, imageStoragePath: imageStoragePath);
    notifyListeners();
  }
}
