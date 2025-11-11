import 'package:flutter/material.dart';
import 'package:cs_310_project/core/mock/mock_outfits.dart';
import 'package:cs_310_project/core/constants/app_text_styles.dart';
import 'package:cs_310_project/core/constants/app_colors.dart';
import 'package:cs_310_project/widgets/outfit_item.dart';

class MyOutfitPage extends StatefulWidget {
  const MyOutfitPage({super.key});

  @override
  State<MyOutfitPage> createState() => _MyOutfitPageState();
}

class _MyOutfitPageState extends State<MyOutfitPage> {
  @override
  Widget build(BuildContext context) {
    final outfits = MockOutfits.list; // mock veriler

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('My Outfits'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.pushNamed(context, "/outfit_creator");
          if (created == true && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Outfit saved successfully")),
            );
            setState(() {}); // listeyi tazele
          }
        },
        backgroundColor: AppColors.textDark,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: outfits.isEmpty
            ? Center(
          child: Text(
            "Henüz kombinin yok",
            style: AppTextStyles.subtitle,
          ),
        )
            : ListView.separated(
          itemCount: outfits.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final outfit = outfits[index];
            return OutfitItem(
              outfit: outfit,
              onTap: () => Navigator.pushNamed(
                context,
                "/outfit_detail",
                arguments: outfit, // ✅ outfit’i detail sayfasına gönder
              ),
            );
          },
        ),
      ),
    );
  }
}
