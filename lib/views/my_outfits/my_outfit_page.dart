import 'package:flutter/material.dart';
import 'package:cs_310_project/models/outfit_model.dart';
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
  Widget build(BuildContext context) {
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
          // Navigate to creator and wait for a result to refresh or notify
          final created = await Navigator.pushNamed(context, "/outfit_creator");

          if (created == true && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Outfit saved successfully")),
            );
            // Trigger rebuild if a new outfit was added
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
        child: StreamBuilder<List<Outfit>>(
          // Listening to real-time updates from the OutfitsProvider
          stream: context.watch<OutfitsProvider>().outfitsStream,
          builder: (context, snapshot) {
            final outfits = snapshot.data ?? const <Outfit>[];

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (outfits.isEmpty) {
              return Center(
                child: Text(
                  "No outfits yet.",
                  style: textTheme.bodyLarge?.copyWith(
                    color: scheme.onBackground,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }

            return ListView.separated(
              itemCount: outfits.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final outfit = outfits[index];

                return OutfitItem(
                  outfit: outfit,
                  onTap: () async {
                    // Pass the selected outfit to the detail view
                    final updated = await Navigator.pushNamed(
                      context,
                      "/outfit_detail",
                      arguments: outfit,
                    );

                    // Refresh state if the detail view modified the outfit
                    if (updated == true && mounted) {
                      setState(() {});
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
