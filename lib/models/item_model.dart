class ClosetItemModel {
  final String? id; // Added ID to track Firestore document
  final String name;
  final String category;
  final String color;
  final String style;
  final String season;
  final String imagePath; // asset path or download URL

  ClosetItemModel({
    this.id, 
    required this.name,
    required this.category,
    required this.style,
    required this.season,
    required this.color,
    required this.imagePath,
  });

  // Helper to convert Firestore data to Model
  factory ClosetItemModel.fromMap(Map<String, dynamic> data, String docId) {
    return ClosetItemModel(
      id: docId,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      style: data['style'] ?? '',
      season: data['season'] ?? '',
      color: data['color'] ?? '',
      // Prioritize storage path, fall back to imageUrl, fall back to placeholder
      imagePath: data['imageUrl'] ?? 'lib/core/mock/mock_images/white_placeholder.png',
    );
  }
}