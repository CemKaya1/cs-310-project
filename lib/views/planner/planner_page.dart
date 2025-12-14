import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cs_310_project/core/mock/mock_outfits.dart';
import 'package:cs_310_project/models/outfit_model.dart';
import 'package:cs_310_project/widgets/outfit_item.dart';
import 'package:cs_310_project/models/planner_entry_model.dart';
import 'package:cs_310_project/views/planner/planner_provider.dart';

class PlannerPage extends StatefulWidget {
  const PlannerPage({super.key});

  @override
  State<PlannerPage> createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> {
  @override
  Widget build(BuildContext context) {
    final days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final plannerProvider = Provider.of<PlannerProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: scheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: scheme.surface,
        title: Text(
          "Planner",
          style: textTheme.titleLarge?.copyWith(
            color: scheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === GÜN İSİMLERİ ===
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: days.map((d) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: scheme.onBackground,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 8),

              // === FIREBASE GRID (Takvim) ===
              StreamBuilder<List<PlannerEntry>>(
                stream: plannerProvider.plannerEntriesStream,
                builder: (context, snapshot) {

                  // Veritabanından gelen veriyi kolay erişim için Map'e çeviriyoruz
                  // Key: gridIndex, Value: PlannerEntry
                  Map<int, PlannerEntry> filledSlots = {};
                  if (snapshot.hasData) {
                    for (var entry in snapshot.data!) {
                      filledSlots[entry.gridIndex] = entry;
                    }
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6,
                    ),
                    itemCount: 28,
                    itemBuilder: (context, index) {
                      final entry = filledSlots[index];

                      return DragTarget<Outfit>(
                        onAccept: (Outfit outfit) {
                          // Mock Outfit'i Firebase'e kaydet
                          plannerProvider.assignOutfitToDay(index, outfit);
                        },
                        
                        builder: (context, candidate, rejected) {
                          final bool isHovering = candidate.isNotEmpty;

                          return GestureDetector(
                            onTap: () {
                              // Tıklayınca sil (Firebase'den)
                              if (entry != null) {
                                plannerProvider.removeOutfitFromDay(index);
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isHovering
                                    ? scheme.primaryContainer.withOpacity(0.4)
                                    : scheme.surface,
                                border: Border.all(
                                  color: scheme.outlineVariant,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                // Eğer Firebase'de veri varsa resmini göster
                                image: entry != null && entry.outfitImagePath.isNotEmpty
                                    ? DecorationImage(
                                  // Mock resimler asset olduğu için AssetImage kullanıyoruz.
                                  // Eğer internet resmi olsaydı NetworkImage kullanacaktık.
                                  image: AssetImage(entry.outfitImagePath),
                                  fit: BoxFit.cover,
                                )
                                    : null,
                              ),
                              padding: const EdgeInsets.all(3),
                              // Eğer resim yüklenemezse veya yoksa ikon göster
                              child: entry == null
                                  ? const SizedBox.shrink()
                                  : null,
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 20),

              Text(
                "Saved Outfits",
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: scheme.onBackground,
                ),
              ),

              const SizedBox(height: 10),

              // === MOCK OUTFIT LISTESI (Sürüklenecek Kaynak) ===
              // Burası DEĞİŞMEDİ, eski Mock listen
              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: MockOutfits.list.length,
                  itemBuilder: (context, index) {
                    final outfit = MockOutfits.list[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: OutfitItem(
                        outfit: outfit,
                        draggable: true, // Sürüklenebilir yaptık
                        compact: false,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
