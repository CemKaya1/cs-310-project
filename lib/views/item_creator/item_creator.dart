import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cs_310_project/models/item_model.dart';
import 'package:cs_310_project/core/mock/mock_items.dart';
import 'package:provider/provider.dart';

import 'package:cs_310_project/views/item_creator/item_creator_provider.dart';

class ItemCreatorPage extends StatefulWidget {
  const ItemCreatorPage({super.key});

  @override
  State<ItemCreatorPage> createState() => _ItemCreatorPageState();
}

class _ItemCreatorPageState extends State<ItemCreatorPage> {
  final _formKey = GlobalKey<FormState>();
  // Text controllers for form inputs
  final _nameCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _styleCtrl = TextEditingController();
  final _seasonCtrl = TextEditingController();
  final _colorCtrl = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;
  bool _saving = false; // Prevents duplicate submissions and shows loading UI
  
  // Opens the gallery to pick an image and updates local state
  Future<void> _pickImage() async {
    try {
      final XFile? img = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
        maxWidth: 2048,
      );

      if (img != null) {
        setState(() => _pickedImage = img);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image pick failed: $e")),
      );
    }
  }

  // Validates the form and triggers both local and remote data saving
  void _saveItem() {
    if (_saving) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

  final provider = context.read<ItemCreatorProvider>();

        final File? imageFile = _pickedImage != null ? File(_pickedImage!.path) : null;
        const String placeholderAsset = 'lib/core/mock/mock_images/white_placeholder.png';

        // 1. Update local mock list for immediate UI feedback in the app
        final newItem = ClosetItemModel(
          name: _nameCtrl.text.trim(),
          category: _categoryCtrl.text.trim(),
          style: _styleCtrl.text.trim(),
          season: _seasonCtrl.text.trim(),
          color: _colorCtrl.text.trim(),
          imagePath: placeholderAsset,
        );

        MockItems.list.insert(0, newItem);
    
  // 2. Persist to Firestore via the Provider
  provider.saveItem(
          name: _nameCtrl.text.trim(),
          category: _categoryCtrl.text.trim(),
          style: _styleCtrl.text.trim(),
          season: _seasonCtrl.text.trim(),
          color: _colorCtrl.text.trim(),
          imageFile: imageFile,
        ).then((ok) {
          Navigator.pop(context, true); // Still pop even if cloud fail, as local is updated
        }).catchError((e) {
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save to cloud: $e')),
          );
          Navigator.pop(context, true);
        }).whenComplete(() {
          if (mounted) setState(() => _saving = false);
        });
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

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        "Upload Image",
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: scheme.onBackground,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Image Selection Container
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: double.infinity,
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: scheme.outlineVariant),
                            color: scheme.surface,
                            boxShadow: [
                              BoxShadow(
                                color: scheme.shadow.withOpacity(0.12),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: _pickedImage == null
                              ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt_outlined,
                                  color: scheme.onSurface, size: 40),
                              const SizedBox(height: 12),
                              Text(
                                "Upload Image",
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: scheme.onSurface,
                                ),
                              ),
                            ],
                          )
                              : ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              File(_pickedImage!.path),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Item Details Form
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _field("Item Name", _nameCtrl, scheme, textTheme),
                            const SizedBox(height: 12),
                            _field("Category", _categoryCtrl, scheme, textTheme),
                            const SizedBox(height: 12),
                            _field("Style", _styleCtrl, scheme, textTheme),
                            const SizedBox(height: 12),
                            _field("Season", _seasonCtrl, scheme, textTheme),
                            const SizedBox(height: 12),
                            _field("Color", _colorCtrl, scheme, textTheme),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _saving ? null : () => Navigator.pop(context, false),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: scheme.onSurface,
                                side: BorderSide(color: scheme.outlineVariant),
                                padding:
                                const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text("Cancel"),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _saving ? null : _saveItem,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: scheme.primary,
                                foregroundColor: scheme.onPrimary,
                                padding:
                                const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _saving
                                  ? const SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Text("Save"),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Reusable UI component for form text fields
  Widget _field(
      String label,
      TextEditingController ctrl,
      ColorScheme scheme,
      TextTheme textTheme,
      ) {
    return TextFormField(
      controller: ctrl,
      validator: (v) =>
      (v == null || v.trim().isEmpty) ? "$label is required" : null,
      style: textTheme.bodyMedium?.copyWith(
        color: scheme.onSurface,
      ),
      cursorColor: scheme.primary,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: scheme.onSurface),
        filled: true,
        fillColor: scheme.surface,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),
    );
  }

}

