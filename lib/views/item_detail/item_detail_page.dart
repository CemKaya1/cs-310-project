import 'package:cs_310_project/views/my_closet/closet_provider.dart';
import 'package:cs_310_project/models/item_doc_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:cs_310_project/services/firestore_service.dart';

class ItemDetailPage extends StatefulWidget {
  const ItemDetailPage({super.key});

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  bool _isEditing = false;
  bool _saving = false;
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _styleController;
  late TextEditingController _seasonController;
  late TextEditingController _colorController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get the item passed from MyClosetPage
    final item = ModalRoute.of(context)!.settings.arguments as ItemDoc;
    
    _nameController = TextEditingController(text: item.name);
    _categoryController = TextEditingController(text: item.category);
    _styleController = TextEditingController(text: item.style);
    _seasonController = TextEditingController(text: item.season);
    _colorController = TextEditingController(text: item.color);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _styleController.dispose();
    _seasonController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  Widget _buildImage(String path) {
    if (path.startsWith('http')) {
      return Image.network(path, fit: BoxFit.contain);
    } else if (path.startsWith('lib/') || path.startsWith('assets/')) {
      return Image.asset(path, fit: BoxFit.contain);
    } else {
      return Image.file(File(path), fit: BoxFit.contain);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final item = ModalRoute.of(context)!.settings.arguments as ItemDoc;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: const Text("Item Details", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Container(
                height: 280,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: _buildImage(item.imageUrl),
                ),
              ),
              const SizedBox(height: 20),
              
              if (_isEditing)
                 TextField(
                  controller: _nameController,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(border: UnderlineInputBorder()),
                )
              else
                Text(
                  _nameController.text,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),

              const SizedBox(height: 30),
              _buildDetailField(label: "Category", controller: _categoryController, theme: theme),
              const SizedBox(height: 16),
              _buildDetailField(label: "Style", controller: _styleController, theme: theme),
              const SizedBox(height: 16),
              _buildDetailField(label: "Season", controller: _seasonController, theme: theme),
              const SizedBox(height: 16),
              _buildDetailField(label: "Color", controller: _colorController, theme: theme),
              const SizedBox(height: 40),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        if (_saving) return;
                        if (_isEditing) {
                          setState(() => _saving = true);
                          // Update Firestore
                          await context.read<ClosetProvider>().updateItem(item.id, {
                            'name': _nameController.text,
                            'category': _categoryController.text,
                            'style': _styleController.text,
                            'season': _seasonController.text,
                            'color': _colorController.text,
                          });
                          if (mounted) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(content: Text("Updated!")));
                          }
                          if (mounted) setState(() => _saving = false);
                        }
                        setState(() => _isEditing = !_isEditing);
                      },
                      icon: Icon(_isEditing ? Icons.check : Icons.edit),
                      label: Text(_isEditing ? "Save" : "Edit"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (_saving) return;
                        setState(() => _saving = true);
                        // Confirm deletion
                        bool? confirm = await showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: colorScheme.surface,
                            titleTextStyle: TextStyle(
                              color: colorScheme.onSurface,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                            contentTextStyle: TextStyle(
                              color: colorScheme.onSurface,
                              fontSize: 16,
                            ),
                            title: const Text("Delete Item"),
                            content: const Text("Are you sure you want to delete this item?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: Text("Cancel", style: TextStyle(color: colorScheme.primary)),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: Text("Delete", style: TextStyle(color: colorScheme.error)),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await FirestoreService()
                              .removeItemFromOutfits(itemImagePath: item.imageUrl);
                          // Note: If imagePath was stored in Firestore as 'imagePath', use it. 
                          // The Seed service used 'imageUrl' for asset path.
                          await context.read<ClosetProvider>().deleteItem(item.id); 
                          Navigator.of(context).pop();
                        } else {
                          if (mounted) setState(() => _saving = false);
                        }
                      },
                      icon: const Icon(Icons.delete_outline),
                      label: const Text("Delete"),
                      style: ElevatedButton.styleFrom(backgroundColor: colorScheme.error, foregroundColor: colorScheme.onError),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailField({required String label, required TextEditingController controller, required ThemeData theme}) {
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: scheme.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(fontWeight: FontWeight.bold, color: scheme.onSurface),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: _isEditing,
              style: TextStyle(color: scheme.onSurface),
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
        ],
      ),
    );
  }
}
