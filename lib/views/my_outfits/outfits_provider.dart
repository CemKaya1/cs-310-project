import 'package:flutter/material.dart';
import 'package:cs_310_project/models/outfit_model.dart';
import 'package:cs_310_project/services/firestore_service.dart';
import 'package:cs_310_project/models/item_model.dart';

/// Manages the state and business logic for User Outfits, 
/// acting as a bridge between the UI and Firestore service.
class OutfitsProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();

  // Exposes a real-time stream of outfits for the UI to consume via StreamBuilder
  Stream<List<Outfit>> get outfitsStream => _service.getOutfitsStream();

  /// Seeds the database with mock data for testing or first-time setup
  Future<void> hydrateMockOutfitsFromFirestore() async {
    await _service.hydrateMockOutfitsFromFirestore();
    notifyListeners();
  }

  /// Saves a pre-constructed Outfit object directly to Firestore
  Future<void> addOutfit(Outfit outfit) async {
    await _service.saveUserOutfit(outfit);
    notifyListeners();
  }

  /// Creates a new outfit, handling optional local image uploads to storage
  /// returns the unique ID of the newly created Firestore document
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

  /// Updates only the name of an existing outfit document
  Future<void> updateOutfitName({required String outfitId, required String name}) async {
    await _service.updateOutfitName(outfitId: outfitId, name: name);
    notifyListeners();
  }

  /// Replaces the items and name of an existing outfit
  Future<void> updateOutfit({
    required String outfitId,
    required String name,
    required List<ClosetItemModel> items,
  }) async {
    await _service.updateOutfit(outfitId: outfitId, name: name, items: items);
    notifyListeners();
  }

  /// Removes the outfit document and optionally cleans up its associated storage image
  Future<void> deleteOutfit({required String outfitId, String? imageStoragePath}) async {
    await _service.deleteOutfit(outfitId: outfitId, imageStoragePath: imageStoragePath);
    notifyListeners();
  }
}
