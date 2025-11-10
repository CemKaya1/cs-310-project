import 'package:flutter/material.dart';
import 'package:cs_310_project/core/mock/mock_outfits.dart';
import 'package:cs_310_project/core/constants/app_text_styles.dart';
import 'package:cs_310_project/core/constants/app_colors.dart';
import 'package:cs_310_project/models/outfit_model.dart';

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
            final Outfit outfit = outfits[index];
            return InkWell(
              onTap: () => Navigator.pushNamed(context, "/outfit_detail"),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 2))],
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      outfit.imagePath,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(outfit.name, style: AppTextStyles.title),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
