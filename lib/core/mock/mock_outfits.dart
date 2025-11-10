import 'package:cs_310_project/models/outfit_model.dart';
import 'package:cs_310_project/core/mock/mock_items.dart';

class MockOutfits {
  static final List<Outfit> list = [
    Outfit(
      name: "Casual Blue",
      items: [
        MockItems.list[1], // Blue T-Shirt
        MockItems.list[3], // Blue Jeans
      ],
      imagePath: "lib/core/mock/mock_images/blue_tshirt.jpg",
    ),
    Outfit(
      name: "Street Black",
      items: [
        MockItems.list[0], // Black T-Shirt
        MockItems.list[2], // Black Jeans
      ],
      imagePath: "lib/core/mock/mock_images/black_tshirt.jpg",
    ),
  ];
}
