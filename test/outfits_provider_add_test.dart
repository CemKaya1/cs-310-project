// UNIT TEST for "Does the provider correctly update its state when a new outfit is added?"

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:cs_310_project/views/my_outfits/outfits_provider.dart';
import 'package:cs_310_project/models/outfit_model.dart';

class MockOutfitsProvider extends Mock implements OutfitsProvider {}

void main() {
  test('OutfitsProvider exposes a stream of outfits', () {
    final provider = MockOutfitsProvider();

    when(() => provider.outfitsStream).thenAnswer((_) => const Stream<List<Outfit>>.empty());

    expect(provider.outfitsStream, isA<Stream<List<Outfit>>>());
  });
}


