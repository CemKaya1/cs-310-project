// WIDGET TEST for "Does the UI correctly reflect state changes when a user adds a new outfit?"

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import 'package:cs_310_project/views/my_outfits/my_outfit_page.dart';
import 'package:cs_310_project/views/my_outfits/outfits_provider.dart';
import 'package:cs_310_project/models/outfit_model.dart';

class MockOutfitsProvider extends Mock implements OutfitsProvider {}

void main() {
  testWidgets('Tapping add button navigates to outfit creator route',
          (WidgetTester tester) async {
        final mockProvider = MockOutfitsProvider();

        when(() => mockProvider.outfitsStream)
            .thenAnswer((_) => const Stream<List<Outfit>>.empty());

        await tester.pumpWidget(
          ChangeNotifierProvider<OutfitsProvider>.value(
            value: mockProvider,
            child: MaterialApp(
              home: const MyOutfitPage(),
              routes: {
                '/outfit_creator': (_) => const Scaffold(
                  body: Center(child: Text('Outfit Creator Page')),
                ),
              },
            ),
          ),
        );

        await tester.pumpAndSettle();

        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        expect(find.text('Outfit Creator Page'), findsOneWidget);
      });
}
