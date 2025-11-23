class ClosetItemModel {
  final String name;
  final String category;
  final String color;
  final String style;
  final String season;
  final String imagePath; // asset path

  ClosetItemModel({
    required this.name,
    required this.category,
    required this.style,
    required this.season,
    required this.color,
    required this.imagePath,
  });
}
