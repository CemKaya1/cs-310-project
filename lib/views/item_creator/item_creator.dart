import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cs_310_project/models/item_model.dart';
import 'package:cs_310_project/core/mock/mock_items.dart';

class ItemCreatorPage extends StatefulWidget {
  const ItemCreatorPage({super.key});

  @override
  State<ItemCreatorPage> createState() => _ItemCreatorPageState();
}

class _ItemCreatorPageState extends State<ItemCreatorPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _styleCtrl = TextEditingController();
  final _seasonCtrl = TextEditingController();
  final _colorCtrl = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;

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


  void _saveItem() {
    if (!_formKey.currentState!.validate()) return;

  // MODIFIED START: get provider to persist data to Firestore (non-blocking UX)
  final provider = context.read<ItemCreatorProvider>();

  // We don't use Firebase Storage. Use a mock string URL if an image file
  // was picked (to represent uploaded URL) or fallback to an asset path.
        final String imageUrl = _pickedImage != null
            ? 'https://example.com/mock_images/${DateTime.now().millisecondsSinceEpoch}.jpg'
            : 'lib/core/mock/mock_images/white_placeholder.png';

        // Keep adding to local mock list for immediate UI feedback (unchanged behavior)
        final newItem = ClosetItemModel(
          name: _nameCtrl.text.trim(),
          category: _categoryCtrl.text.trim(),
          style: _styleCtrl.text.trim(),
          season: _seasonCtrl.text.trim(),
          color: _colorCtrl.text.trim(),
          imagePath: imageUrl,
        );

        MockItems.list.insert(0, newItem);

  // Also persist to Firestore via provider (real-time updates will flow via streams elsewhere)
  // MODIFIED: provider.saveItem called to persist item document under users/{uid}/items
  provider.saveItem(
          name: _nameCtrl.text.trim(),
          category: _categoryCtrl.text.trim(),
          style: _styleCtrl.text.trim(),
          season: _seasonCtrl.text.trim(),
          color: _colorCtrl.text.trim(),
          imageUrl: imageUrl,
        ).then((ok) {
          Navigator.pop(context, true);
        }).catchError((e) {
          // If Firestore write fails, still close but show message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save to cloud: $e')),
          );
          Navigator.pop(context, true);
        });
  // MODIFIED END
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
      // -------------------------------------

      body: SafeArea(
        child: Padding(
          // Üstteki AppBar geldiği için dikey padding'i biraz azalttık veya ihtiyaca göre düzenledik
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ESKİ "Row" (Back button) BURADAN SİLİNDİ.

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      //  Upload Image Title
                      Text(
                        "Upload Image",
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: scheme.onBackground,
                        ),
                      ),

                      const SizedBox(height: 12),

                      //  Upload Container
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

                      //  Form Fields
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

                      //  Cancel + Save Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context, false),
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
                              onPressed: _saveItem,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: scheme.primary,
                                foregroundColor: scheme.onPrimary,
                                padding:
                                const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text("Save"),
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

  //  Form Field Component
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
