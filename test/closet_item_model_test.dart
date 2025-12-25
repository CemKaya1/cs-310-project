// UNIT TEST for "Does the model correctly map data coming from Firestore into its fields?"

import 'package:flutter_test/flutter_test.dart';
import 'package:cs_310_project/models/item_model.dart';

void main() {
  test('ClosetItemModel.fromMap creates model with correct fields', () {
    // Arrange
    final firestoreData = {
      'name': 'Black Turtleneck',
      'category': 'Top',
      'style': 'Casual',
      'season': 'Winter',
      'color': 'Black',
      'imageUrl': 'assets/images/black_turtleneck.png',
    };

    // Act
    final item = ClosetItemModel.fromMap(firestoreData, 'doc123');

    // Assert
    expect(item.id, 'doc123');
    expect(item.name, 'Black Turtleneck');
    expect(item.category, 'Top');
    expect(item.style, 'Casual');
    expect(item.season, 'Winter');
    expect(item.color, 'Black');
    expect(item.imagePath, 'assets/images/black_turtleneck.png');
  });
}
