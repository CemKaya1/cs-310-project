import 'package:flutter/material.dart';
import 'package:cs_310_project/models/outfit_model.dart';
import 'package:cs_310_project/widgets/closet_item.dart';
import 'package:cs_310_project/widgets/outfit_item.dart';
import 'package:provider/provider.dart';
import 'package:cs_310_project/views/my_outfits/outfits_provider.dart';

//Detail page for viewing, editing, and deleting a single outfit
class OutfitDetailPage extends StatefulWidget {
  const OutfitDetailPage({super.key});

  @override
  State<OutfitDetailPage> createState() => _OutfitDetailPageState();
}

class _OutfitDetailPageState extends State<OutfitDetailPage> {
  
  //Whether the page is currently in edit mode
  bool isEditing = false;

  //Prevents multiple save/delete operations at the same time
  bool _saving = false;

  //Outfit data passed from the previous screen
  late Outfit outfit;

  //Controller for editing the outfit name
  late TextEditingController _nameCtrl;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    //Get the outfit passed via Navigator arguments
    //If none is provided, create a default outfit
    outfit = (ModalRoute.of(context)?.settings.arguments as Outfit?) ??
        Outfit(name: 'New Outfit', items: [], imagePath: '');

    //Initialize the text controller with the outfit name
    _nameCtrl = TextEditingController(text: outfit.name);
  }

  @override
  void dispose() {
    
    //Dispose the controller to free resources
    _nameCtrl.dispose();
    super.dispose();
  }

  //Saves edited outfit name and items to Firestore
  Future<void> _saveChanges() async {
    if (_saving) return;

    final newName = _nameCtrl.text.trim();

    if (newName.isNotEmpty) {
      
      // Update local outfit name
      setState(() => outfit.name = newName);

      //Update Firestore if the outfit already exists
      if (outfit.id != null) {
        setState(() => _saving = true);
        await context.read<OutfitsProvider>().updateOutfit(
              outfitId: outfit.id!,
              name: newName,
              items: outfit.items,
            );
        if (mounted) setState(() => _saving = false);
      }

      //Show confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Outfit updated")),
      );
    }

    //Exit edit mode and return to previous screen
    setState(() => isEditing = false);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    
    //Theme helpers
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: scheme.background,

      //Top app bar with back navigation
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

      //Page content
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            //Outfit preview card
            Center(child: OutfitItem(outfit: outfit)),
            const SizedBox(height: 16),

            //Outfit name
            if (isEditing)
              TextField(
                controller: _nameCtrl,
                style: textTheme.bodyLarge?.copyWith(color: scheme.onSurface),
                decoration: InputDecoration(
                  labelText: "Outfit Name",
                  filled: true,
                  fillColor: scheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
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

            //Section title
            Text(
              "Included Items",
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: scheme.onBackground,
              ),
            ),

            const SizedBox(height: 12),

            //List of clothing items in the outfit
            Expanded(
              child: ListView.builder(
                itemCount: outfit.items.length,
                itemBuilder: (context, index) {
                  final item = outfit.items[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Stack(
                      children: [
                        
                        //Clothing item card
                        SizedBox(
                          width: double.infinity,
                          child: ClosetItem(
                            imagePath: item.imagePath,
                            name: item.name,
                          ),
                        ),

                        //Remove item button
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

            //Action buttons: Edit/Save and Delete
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                
                //Edit/Save button
                OutlinedButton.icon(
                  onPressed: isEditing
                      ? (_saving ? null : _saveChanges)
                      : () => setState(() => isEditing = true),
                  icon: Icon(isEditing ? Icons.save : Icons.edit),
                  label: Text(isEditing ? "Save" : "Edit"),
                ),

                //Delete button with confirmation dialog
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
                        title: const Text("Delete Outfit"),
                        content: const Text(
                            "Are you sure you want to delete this outfit?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text("Delete"),
                          ),
                        ],
                      ),
                    );

                    if (confirm != true) {
                      if (mounted) setState(() => _saving = false);
                      return;
                    }

                    //Delete outfit from Firestore
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
