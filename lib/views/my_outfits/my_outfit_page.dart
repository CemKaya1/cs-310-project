import 'package:flutter/material.dart';
import 'package:cs_310_project/core/mock/mock_outfits.dart';
import 'package:cs_310_project/widgets/outfit_item.dart';
import 'package:provider/provider.dart';
import 'package:cs_310_project/views/my_outfits/outfits_provider.dart';


class MyOutfitPage extends StatefulWidget {
  const MyOutfitPage({super.key});

  @override
  State<MyOutfitPage> createState() => _MyOutfitPageState();
}

class _MyOutfitPageState extends State<MyOutfitPage> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<OutfitsProvider>().hydrateMockOutfitsFromFirestore();
    });
  }

  @override
  Widget build(BuildContext context) {
    final outfits = MockOutfits.list;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: scheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: scheme.surface,
        title: Text(
          "My Outfits",
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: scheme.onSurface,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.pushNamed(context, "/outfit_creator");

          if (created == true && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Outfit saved successfully")),
            );
            setState(() {});
          }
        },

        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

        child: outfits.isEmpty
            ? Center(
          child: Text(
            "Henüz kombinin yok",
            style: textTheme.bodyLarge?.copyWith(
              color: scheme.onBackground,
              fontWeight: FontWeight.w500,
            ),
          ),
        )

            : ListView.separated(
          itemCount: outfits.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final outfit = outfits[index];

            return OutfitItem(
              outfit: outfit,
              onTap: () async {
                final updated = await Navigator.pushNamed(
                  context,
                  "/outfit_detail",
                  arguments: outfit,
                );

                if (updated == true && mounted) {
                  setState(() {});
                }
              },
            );
          },
        ),
      ),
    );
  }
}
