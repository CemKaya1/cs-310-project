import 'package:cs_310_project/models/item_model.dart';

class Outfit {
  String name;
  List<ClosetItemModel> items;
  String imagePath;

  Outfit({
    required this.name,
    required this.items,
    required this.imagePath,
  });
}
