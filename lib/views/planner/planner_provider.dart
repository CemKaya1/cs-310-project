import 'package:flutter/material.dart';
import 'package:cs_310_project/models/planner_entry_model.dart';
import 'package:cs_310_project/models/outfit_model.dart'; // Senin eski model
import 'package:cs_310_project/services/firestore_service.dart';

class PlannerProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();

  Stream<List<PlannerEntry>> get plannerEntriesStream => _service.getPlannerEntriesStream();

  Future<void> assignOutfitToDay(int index, Outfit outfit) async {
    await _service.savePlannerEntry(index, outfit);
    notifyListeners();
  }

  Future<void> removeOutfitFromDay(int index) async {
    await _service.removePlannerEntry(index);
    notifyListeners();
  }
}