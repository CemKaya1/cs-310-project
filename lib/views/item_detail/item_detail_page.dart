import 'package:cs_310_project/core/mock/mock_items.dart';
import 'package:flutter/material.dart';

class ItemDetailPage extends StatefulWidget {

  const ItemDetailPage({
    super.key,

  });

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  // to be aware whether we are in edit more or not
  bool _isEditing = false;
  late final TextEditingController _categoryController;
  late final TextEditingController _styleController;
  late final TextEditingController _seasonController;
  late final TextEditingController _colorController;

  @override
  void initState() {
    super.initState();
    _categoryController = TextEditingController(text: "");
    _styleController = TextEditingController(text: "");
    _seasonController = TextEditingController(text: "");
    _colorController = TextEditingController(text: "");
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _styleController.dispose();
    _seasonController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    // Get the current theme data
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final int? index = args['index'] as int?;
    final String itemName = args['name'] as String;
    final String imagePath = args['image'] as String;
    return Scaffold(
      // Uses the global scaffold background (White in Light, Dark Grey/Black in Dark)
      backgroundColor: theme.scaffoldBackgroundColor, 
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leadingWidth: 100,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            padding: const EdgeInsets.only(left: 16),
            color: Colors.transparent,
            child: Row(
              children: [
                Icon(Icons.arrow_back, color: colorScheme.onSurface, size: 24),
                const SizedBox(width: 4),
                Text(
                  "Back",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface, 
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Product Image Area
              Container(
                height: 280,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Image.asset(
                    imagePath,
                    errorBuilder: (context, error, stackTrace) => 
                        Icon(Icons.image_not_supported, size: 80, color: colorScheme.onSurface.withOpacity(0.5)),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Text(
  itemName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface, 
                ),
              ),

              const SizedBox(height: 30),

              // Static Input Fields
              _buildDetailField(label: "Category", controller: _categoryController, theme: theme),
              const SizedBox(height: 16),
              _buildDetailField(label: "Style", controller: _styleController, theme: theme),
              const SizedBox(height: 16),
              _buildDetailField(label: "Season", controller: _seasonController, theme: theme),
              const SizedBox(height: 16),
              _buildDetailField(label: "Color", controller: _colorController, theme: theme),

              const SizedBox(height: 40),

              // Buttons Row
              Row(
                children: [
                  // Edit button when clicked toggles isediting and chagnes icon and label
                  // goes to be a save button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _isEditing = !_isEditing;
                        });
                      },
                      icon: Icon(
                        _isEditing ? Icons.check_circle_outline : Icons.edit_outlined,
                        size: 18,
                        color: colorScheme.onSurface,
                      ),
                      label: Text(
                        _isEditing ? "Save" : "Edit",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: theme.dividerColor), 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Delete Button
                  // deletes and pops to the previous screen also sets state there as well
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (index! >= 0 && index < MockItems.list.length) {
                          MockItems.list.removeAt(index);
                        }
                        Navigator.of(context).pop(true);
                      },
                      icon: Icon(Icons.delete_outline, size: 18, color: colorScheme.onError),
                      label: Text(
                        "Delete",
                        style: TextStyle(color: colorScheme.onError, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.error,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

// static data holder widget builder holds both the data and editing fields when it is edit mode
  Widget _buildDetailField({
    required String label,
    required TextEditingController controller,
    required ThemeData theme,
  }) {
    final onSurface = theme.colorScheme.onSurface;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor), 
        borderRadius: BorderRadius.circular(12),
        color: theme.cardColor, 
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Label
          Text(
            "$label:",
            style: TextStyle(
              color: onSurface.withOpacity(0.7), 
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(width: 10),

          Expanded(
            child: _isEditing
                ? TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      hintText: "Enter value",
                      hintStyle: TextStyle(color: onSurface.withOpacity(0.4)), 
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      color: onSurface, 
                    ),
                    cursorColor: theme.colorScheme.primary, 
                  )
                : Text(
                    controller.text.isEmpty ? "" : controller.text,
                    style: TextStyle(
                      color: onSurface, 
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
          ),
        ],
      ),
    );
  }
}