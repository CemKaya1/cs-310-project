import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cs_310_project/core/mock/mock_items.dart';
import 'package:cs_310_project/models/item_model.dart';

import 'package:provider/provider.dart';
import 'package:cs_310_project/views/my_outfits/outfits_provider.dart';


class OutfitCreatorPage extends StatefulWidget {
  const OutfitCreatorPage({super.key});

  @override
  State<OutfitCreatorPage> createState() => _OutfitCreatorPageState();
}

class _OutfitCreatorPageState extends State<OutfitCreatorPage> {
  final _nameCtrl = TextEditingController();

  final Set<String> _selectedKeys = {};
  late final List<ClosetItemModel> _rows = MockItems.list;

  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;

  String _keyOf(ClosetItemModel it) => it.imagePath;

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
        maxWidth: 2048,
      );

      if (file != null) {
        setState(() => _pickedImage = file);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image pick failed: $e')),
      );
    }
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

      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    foregroundColor: scheme.onSurface,
                    side: BorderSide(color: scheme.outlineVariant),
                  ),
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: scheme.primary,
                    foregroundColor: scheme.onPrimary,
                  ),
                  onPressed: _onSave,
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),

      // Body
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        children: [
          // Upload Image
          GestureDetector(
            onTap: _pickImageFromGallery,
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: scheme.outlineVariant, width: 1.5),
              ),
              child: Center(
                child: _pickedImage == null
                    ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.photo_camera_outlined,
                      size: 32,
                      color: scheme.onSurface,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Upload Image',
                      style: textTheme.bodyLarge?.copyWith(
                        color: scheme.onSurface,
                      ),
                    ),
                  ],
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(_pickedImage!.path),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Outfit Name input
          TextField(
            controller: _nameCtrl,
            style: textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
            decoration: InputDecoration(
              hintText: 'Outfit Name',
              hintStyle: textTheme.bodyMedium?.copyWith(
                color: scheme.onSurface.withOpacity(0.6),
              ),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                borderSide: BorderSide(color: scheme.primary, width: 2),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Container(
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: scheme.outlineVariant, width: 1.2),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _rows.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                thickness: 1,
                color: scheme.outlineVariant,
              ),
              itemBuilder: (context, i) {
                final item = _rows[i];
                return _ItemRow(
                  item: item,
                  selected: _selectedKeys.contains(_keyOf(item)),
                  onPlus: () {
                    setState(() {
                      final key = _keyOf(item);
                      if (_selectedKeys.contains(key)) {
                        _selectedKeys.remove(key);
                      } else {
                        _selectedKeys.add(key);
                      }
                    });
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Future<void> _onSave() async {

    final selected =
    _rows.where((it) => _selectedKeys.contains(_keyOf(it))).toList();

    if (selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one item')),
      );
      return;
    }

    final name =
    _nameCtrl.text.trim().isEmpty ? 'New Outfit' : _nameCtrl.text.trim();

    try {
      await context.read<OutfitsProvider>().createOutfit(
            name: name,
            items: selected,
            fallbackImagePath: selected.first.imagePath,
            localImageFilePath: _pickedImage?.path,
          );
    } catch (_) {
      // şimdilik Firestore permission hatası yüzünden geri dönüş engellenmesin
    }

    Navigator.of(context, rootNavigator: true).pop(true);

  }
}

class _ItemRow extends StatelessWidget {
  final ClosetItemModel item;
  final bool selected;
  final VoidCallback onPlus;

  const _ItemRow({
    required this.item,
    required this.selected,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          item.imagePath,
          width: 46,
          height: 46,
          fit: BoxFit.cover,
        ),
      ),

      title: Text(
        item.name,
        style: textTheme.bodyLarge?.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),

      trailing: InkWell(
        onTap: onPlus,
        borderRadius: BorderRadius.circular(18),

        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: scheme.surface,
            border: Border.all(color: scheme.outlineVariant),
            shape: BoxShape.circle,
          ),

          child: Icon(
            selected ? Icons.check : Icons.add,
            color: scheme.onSurface,
          ),
        ),
      ),
    );
  }
}
