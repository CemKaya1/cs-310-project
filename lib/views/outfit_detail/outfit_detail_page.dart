import 'package:flutter/material.dart';
import 'package:cs_310_project/models/outfit_model.dart';
import 'package:cs_310_project/widgets/closet_item.dart';
import 'package:cs_310_project/widgets/outfit_item.dart';
import 'package:provider/provider.dart';
import 'package:cs_310_project/views/my_outfits/outfits_provider.dart';

class OutfitDetailPage extends StatefulWidget {
  const OutfitDetailPage({super.key});

  @override
  State<OutfitDetailPage> createState() => _OutfitDetailPageState();
}

class _OutfitDetailPageState extends State<OutfitDetailPage> {
  bool isEditing = false;
  bool _saving = false;
  late Outfit outfit;
  late TextEditingController _nameCtrl;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    outfit = (ModalRoute.of(context)?.settings.arguments as Outfit?) ??
        Outfit(name: 'New Outfit', items: [], imagePath: '');
    _nameCtrl = TextEditingController(text: outfit.name);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_saving) return;
    final newName = _nameCtrl.text.trim();

    if (newName.isNotEmpty) {
      setState(() => outfit.name = newName);

      if (outfit.id != null) {
        setState(() => _saving = true);
        await context.read<OutfitsProvider>().updateOutfit(
              outfitId: outfit.id!,
              name: newName,
              items: outfit.items,
            );
        if (mounted) setState(() => _saving = false);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Outfit updated")),
      );
    }

    setState(() => isEditing = false);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: scheme.background,

      appBar: AppBar(
        backgroundColor: scheme.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          outfit.name,
          style: textTheme.titleLarge?.copyWith(
            color: scheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        leadingWidth: 100,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            padding: const EdgeInsets.only(left: 16),
            color: Colors.transparent,
            child: Row(
              children: [
                Icon(Icons.arrow_back, color: scheme.onSurface, size: 24),
                const SizedBox(width: 4),
                Text(
                  "Back",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Center(child: OutfitItem(outfit: outfit)),
            const SizedBox(height: 16),

            // === NAME EDITING ===
            if (isEditing)
              TextField(
                controller: _nameCtrl,
                style: textTheme.bodyLarge?.copyWith(color: scheme.onSurface),
                decoration: InputDecoration(
                  labelText: "Outfit Name",
                  labelStyle: TextStyle(color: scheme.onSurface),
                  filled: true,
                  fillColor: scheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: scheme.outlineVariant),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: scheme.outlineVariant),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                    BorderSide(color: scheme.primary, width: 2),
                  ),
                ),
              )
            else
              Center(
                child: Text(
                  outfit.name,
                  style: textTheme.headlineSmall?.copyWith(
                    color: scheme.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            const SizedBox(height: 20),

            Text(
              "Included Items",
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: scheme.onBackground,
              ),
            ),

            const SizedBox(height: 12),

            // === Items List ===
            Expanded(
              child: ListView.builder(
                itemCount: outfit.items.length,
                itemBuilder: (context, index) {
                  final item = outfit.items[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ClosetItem(
                            imagePath: item.imagePath,
                            name: item.name,
                          ),
                        ),

                        if (isEditing)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  outfit.items.removeAt(index);
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: scheme.error,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: scheme.onError,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // === ACTION BUTTONS ===
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  onPressed: isEditing
                      ? (_saving ? null : _saveChanges)
                      : () => setState(() => isEditing = true),
                  icon: Icon(
                    isEditing ? Icons.save : Icons.edit,
                    color: scheme.onSurface,
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: scheme.outlineVariant),
                  ),
                  label: Text(
                    isEditing ? "Save" : "Edit",
                    style: TextStyle(color: scheme.onSurface),
                  ),
                ),

                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: scheme.error,
                    foregroundColor: scheme.onError,
                  ),
                  onPressed: () async {
                    if (_saving) return;
                    setState(() => _saving = true);
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: scheme.surface,
                        titleTextStyle: TextStyle(
                          color: scheme.onSurface,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        contentTextStyle: TextStyle(
                          color: scheme.onSurface,
                          fontSize: 16,
                        ),
                        title: const Text("Delete Outfit"),
                        content: const Text("Are you sure you want to delete this outfit?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: Text("Cancel", style: TextStyle(color: scheme.primary)),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: Text("Delete", style: TextStyle(color: scheme.error)),
                          ),
                        ],
                      ),
                    );

                    if (confirm != true) {
                      if (mounted) setState(() => _saving = false);
                      return;
                    }

                    if (outfit.id != null) {
                      await context.read<OutfitsProvider>().deleteOutfit(
                            outfitId: outfit.id!,
                            imageStoragePath: outfit.imageStoragePath,
                          );
                    }

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
