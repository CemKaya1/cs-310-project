import 'package:flutter/material.dart';
import 'package:cs_310_project/core/constants/app_colors.dart';
import 'package:cs_310_project/core/constants/app_text_styles.dart';
import 'package:cs_310_project/core/mock/mock_outfits.dart';
import 'package:cs_310_project/models/outfit_model.dart';
import 'package:cs_310_project/widgets/outfit_item.dart';
import 'package:cs_310_project/widgets/closet_item.dart';

class OutfitDetailPage extends StatefulWidget {
  const OutfitDetailPage({super.key});

  @override
  State<OutfitDetailPage> createState() => _OutfitDetailPageState();
}

class _OutfitDetailPageState extends State<OutfitDetailPage> {
  bool isEditing = false;
  late Outfit outfit;
  late TextEditingController _nameCtrl;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    outfit = (ModalRoute.of(context)?.settings.arguments as Outfit?) ??
        MockOutfits.list.first;
    _nameCtrl = TextEditingController(text: outfit.name);
  }

  void _saveChanges() {
    final newName = _nameCtrl.text.trim();
    if (newName.isNotEmpty) {
      setState(() => outfit.name = newName);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Outfit name updated")),
      );
    }
    setState(() => isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(outfit.name, style: AppTextStyles.title),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: OutfitItem(outfit: outfit)),

            const SizedBox(height: 16),

            // === Name edit alanı ===
            if (isEditing)
              TextField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: "Outfit Name",
                  border: OutlineInputBorder(),
                ),
              )
            else
              Center(
                child: Text(
                  outfit.name,
                  style: AppTextStyles.title.copyWith(fontSize: 22),
                ),
              ),

            const SizedBox(height: 16),
            Text("Included Items", style: AppTextStyles.title),
            const SizedBox(height: 10),

            // === Item listesi ===
            Expanded(
              child: ListView.builder(
                itemCount: outfit.items.length,
                itemBuilder: (context, index) {
                  final item = outfit.items[index];
                  return ClosetItem(
                    imagePath: item.imagePath,
                    name: item.name,
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // === Edit / Delete ===
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  onPressed: isEditing ? _saveChanges : () => setState(() => isEditing = true),
                  icon: Icon(
                    isEditing ? Icons.save : Icons.edit,
                    color: AppColors.textDark,
                  ),
                  label: Text(
                    isEditing ? "Save" : "Edit",
                    style: const TextStyle(color: AppColors.textDark),
                  ),
                ),
                FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
                  onPressed: () {
                    MockOutfits.list.remove(outfit);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${outfit.name} deleted")),
                    );
                    Navigator.pop(context, true);
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text("Delete"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
