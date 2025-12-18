import 'package:cloud_firestore/cloud_firestore.dart';

class ItemDoc {
  final String id;
  final String name;
  final String category;
  final String style;
  final String season;
  final String color;
  final String imageUrl;
  final String createdBy;
  final Timestamp? createdAt;

  ItemDoc({
    required this.id,
    required this.name,
    required this.category,
    required this.style,
    required this.season,
    required this.color,
    required this.imageUrl,
    required this.createdBy,
    required this.createdAt,
  });

  factory ItemDoc.fromMap(Map<String, dynamic> data, String docId) {
    return ItemDoc(
      id: docId,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      style: data['style'] ?? '',
      season: data['season'] ?? '',
      color: data['color'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      createdBy: data['createdBy'] ?? '',
      createdAt: data['createdAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'style': style,
      'season': season,
      'color': color,
      'imageUrl': imageUrl,
      'createdBy': createdBy,
      'createdAt': createdAt,
    };
  }
}
