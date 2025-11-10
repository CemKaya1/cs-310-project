import 'package:flutter/material.dart';
import 'package:cs_310_project/core/constants/app_colors.dart';
import 'package:cs_310_project/core/constants/app_text_styles.dart';
import 'package:cs_310_project/core/mock/mock_items.dart';
import 'package:cs_310_project/core/mock/mock_outfits.dart';
import 'package:cs_310_project/models/item_model.dart';
import 'package:cs_310_project/models/outfit_model.dart';

class OutfitCreatorPage extends StatefulWidget {
  const OutfitCreatorPage({super.key});

  @override
  State<OutfitCreatorPage> createState() => _OutfitCreatorPageState();
}

class _OutfitCreatorPageState extends State<OutfitCreatorPage> {
  final _nameCtrl = TextEditingController();

  // Satırlarda seçilenleri tutmak için benzersiz anahtarlar
  final Set<String> _selectedKeys = {};

  // Görseldeki sırayla 4 item
  late final List<ClosetItemModel> _rows = _resolveRows();

  List<ClosetItemModel> _resolveRows() {
    ClosetItemModel pickByName(String name, {String? fallbackCategory}) {
      final list = MockItems.list;
      final byName =
      list.where((e) => e.name.toLowerCase() == name.toLowerCase());
      if (byName.isNotEmpty) return byName.first;
      if (fallbackCategory == null) return list.first;
      final byCat = list.where((e) => e.category == fallbackCategory);
      return byCat.isNotEmpty ? byCat.first : list.first;
    }

    return [
      pickByName('Turtleneck Sweater', fallbackCategory: 'Top'),
      pickByName('Striped T-shirt', fallbackCategory: 'Top'),
      pickByName('Shorts', fallbackCategory: 'Bottom'),
      pickByName('Jacket', fallbackCategory: 'Outer'),
    ];
  }

  String _keyOf(ClosetItemModel it) => it.imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Üstte sadece geri oku olan, başlıksız AppBar
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Back',
        ),
        automaticallyImplyLeading: true,
        title: null,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),

      // ✅ Alt kısımda sabit Cancel / Save
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
                    side: BorderSide(color: Colors.grey.shade400),
                    foregroundColor: AppColors.textDark,
                    textStyle: AppTextStyles.button,
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
                    backgroundColor: AppColors.textDark,
                    foregroundColor: Colors.white,
                    textStyle: AppTextStyles.button,
                  ),
                  onPressed: _onSave,
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        children: [
          // Upload Image kutusu
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade300, width: 1.5),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.photo_camera_outlined,
                      size: 32, color: AppColors.textDark),
                  const SizedBox(height: 8),
                  Text('Upload Image', style: AppTextStyles.subtitle),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Outfit name input
          TextField(
            controller: _nameCtrl,
            decoration: InputDecoration(
              hintText: 'Outfit Name',
              hintStyle:
              AppTextStyles.subtitle.copyWith(color: Colors.grey.shade500),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 4 satırlık liste
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade300, width: 1.2),
            ),
            child: Column(
              children: [
                for (int i = 0; i < _rows.length; i++) ...[
                  _ItemRow(
                    item: _rows[i],
                    selected: _selectedKeys.contains(_keyOf(_rows[i])),
                    onPlus: () {
                      setState(() {
                        final k = _keyOf(_rows[i]);
                        if (_selectedKeys.contains(k)) {
                          _selectedKeys.remove(k);
                        } else {
                          _selectedKeys.add(k);
                        }
                      });
                    },
                  ),
                  if (i != _rows.length - 1)
                    Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey.shade200),
                ],
              ],
            ),
          ),

          // Altta butonlar var; burada ekstra boşluk bırakmayalım
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  void _onSave() {
    // Seçilenleri oluştur
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

    // MockOutfits’e ekle → MyOutfits listesinde görünsün
    final outfit = Outfit(
      name: name,
      items: selected,
      imagePath: selected.first.imagePath, // öne çıkacak görsel
    );
    MockOutfits.list.insert(0, outfit);

    Navigator.pop(context, true); // MyOutfitPage, setState() ile tazeler
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
    return ListTile(
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(item.imagePath,
            width: 46, height: 46, fit: BoxFit.cover),
      ),
      title: Text(item.name, style: AppTextStyles.title),
      trailing: InkWell(
        onTap: onPlus,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            shape: BoxShape.circle,
          ),
          child: Icon(
            selected ? Icons.check : Icons.add,
            color: AppColors.textDark,
          ),
        ),
      ),
    );
  }
}
