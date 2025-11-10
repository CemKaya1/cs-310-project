import 'package:cs_310_project/models/item_model.dart';

class Outfit {
  final String name;
  final List<ClosetItemModel> items;
  final String imagePath; // asset image of outfit preview

  Outfit({
    required this.name,
    required this.items,
    required this.imagePath,
  });
}
