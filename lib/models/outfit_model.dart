import 'package:cs_310_project/models/item_model.dart';

class Outfit {
  String? id;
  String name;
  List<ClosetItemModel> items;
  /// Can be an asset path, local file path, or a http(s) download URL.
  String imagePath;
  /// Storage fullPath, used for delete; optional.
  String? imageStoragePath;

  Outfit({
    this.id,
    required this.name,
    required this.items,
    required this.imagePath,
    this.imageStoragePath,
  });
}
