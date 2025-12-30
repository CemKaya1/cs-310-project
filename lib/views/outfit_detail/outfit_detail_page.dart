import 'package:flutter/material.dart';
import 'package:cs_310_project/models/outfit_model.dart';
import 'package:cs_310_project/widgets/closet_item.dart';
import 'package:cs_310_project/widgets/outfit_item.dart';
import 'package:provider/provider.dart';
import 'package:cs_310_project/views/my_outfits/outfits_provider.dart';

//Displays detailed information about a single outfit
//Allows viewing, editing, and deleting an outfit
class OutfitDetailPage extends StatefulWidget {
  const OutfitDetailPage({super.key});

  @override
  State<OutfitDetailPage> createState() => _OutfitDetailPageState();
}

class _OutfitDetailPageState extends State<OutfitDetailPage> {
  //Whether the page is currently in edit mode
  bool isEditing = false;

  //Prevents multiple save/delete actions at the same time
  bool _saving = false;

  //The outfit being displayed and edited
  late Outfit outfit;

  //Controller for editing the outfit name
  late TextEditingController _nameCtrl;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    //Retrieves the outfit passed via navigation arguments
    //If no outfit is provided, creates a default "New Outfit"
    outfit = (ModalRoute.of(context)?.settings.arguments as Outfit?) ??
        Outfit(name: 'New Outfit', items: [], imagePath: '');

    //Initializes the text controller with the outfit name
    _nameCtrl = TextEditingController(text: outfit.name);
  }

  @override
  void dispose() {
    //Disposes the controller to avoid memory leaks
    _nameCtrl.dispose();
    super.dispose();
  }

  //Saves changes made to the outfit name and items
  Future<void> _saveChanges() async {
    if (_saving) return;

    final newName = _nameCtrl.text.trim();

    if (newName.isNotEmpty) {
      //Update local outfit name
      setState(() => outfit.name = newName);

      //If the outfit exists in Firestore, update it
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
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: scheme.background,

      //App bar showing outfit name and back button
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

        //Custom back button
        leadingWidth: 100,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            padding: const EdgeInsets.only(left: 16),
            color: Colors.transparent,
            child: Row(
