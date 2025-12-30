import 'package:flutter/material.dart';
import 'package:cs_310_project/models/planner_entry_model.dart';
import 'package:cs_310_project/models/outfit_model.dart';
import 'package:cs_310_project/services/firestore_service.dart';

//manages outfit planning logic, 
//communicates with Firestore and notifies the UI when data changes
class PlannerProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();
  
  //Stream that provides real-time planner entries from Firestore
  //Used by the UI to reactively update planned outfits
  Stream<List<PlannerEntry>> get plannerEntriesStream => _service.getPlannerEntriesStream();

  //Assigns an outfit to a specific day in the planner
  //Saves the data to Firestore and notifies listeners
  Future<void> assignOutfitToDay(int index, Outfit outfit) async {
    await _service.savePlannerEntry(index, outfit);
    notifyListeners();
  }

  //Removes the assigned outfit from a specific day
  //Deletes the entry from Firestore and notifies listeners
  Future<void> removeOutfitFromDay(int index) async {
    await _service.removePlannerEntry(index);
    notifyListeners();
  }
}
