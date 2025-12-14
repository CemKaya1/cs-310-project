class PlannerEntry {
  String id;
  int gridIndex; // 0-27 arasındaki kutu numarası
  String outfitName; // Mock veriden gelen isim
  String outfitImagePath; // Mock veriden gelen resim yolu

  PlannerEntry({
    required this.id,
    required this.gridIndex,
    required this.outfitName,
    required this.outfitImagePath,
  });

  // Firebase'den okurken
  factory PlannerEntry.fromMap(Map<String, dynamic> data, String docId) {
    return PlannerEntry(
      id: docId,
      gridIndex: data['gridIndex'] ?? 0,
      outfitName: data['outfitName'] ?? '',
      outfitImagePath: data['outfitImagePath'] ?? '',
    );
  }

  // Firebase'e yazarken
  Map<String, dynamic> toMap() {
    return {
      'gridIndex': gridIndex,
      'outfitName': outfitName,
      'outfitImagePath': outfitImagePath,
    };
  }
}