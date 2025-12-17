import 'package:flutter/material.dart';
import 'package:cs_310_project/models/outfit_model.dart';
import 'package:cs_310_project/services/firestore_service.dart';

class OutfitsProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();

  Future<void> hydrateMockOutfitsFromFirestore() async {
    await _service.hydrateMockOutfitsFromFirestore();
    notifyListeners();
  }

  Future<void> addOutfit(Outfit outfit) async {
    await _service.saveUserOutfit(outfit);
    notifyListeners();
  }
}
