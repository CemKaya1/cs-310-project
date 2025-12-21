import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cs_310_project/models/outfit_model.dart';
import 'package:cs_310_project/widgets/outfit_item.dart';
import 'package:cs_310_project/models/planner_entry_model.dart';
import 'package:cs_310_project/views/planner/planner_provider.dart';
import 'package:cs_310_project/views/my_outfits/outfits_provider.dart';

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
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        plannerProvider.assignOutfitToDay(index, outfit);
                      },
                      builder: (context, candidate, rejected) {
                        final bool isHovering = candidate.isNotEmpty;

                        return GestureDetector(
                          onTap: () {
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
                              image: entry != null && entry.outfitImagePath.isNotEmpty
                                  ? DecorationImage(
                                      image: entry.outfitImagePath.startsWith('http')
                                          ? NetworkImage(entry.outfitImagePath)
                                          : AssetImage(entry.outfitImagePath) as ImageProvider,
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            padding: const EdgeInsets.all(3),
                            child: entry == null ? const SizedBox.shrink() : null,
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

            StreamBuilder<List<Outfit>>(
              stream: context.watch<OutfitsProvider>().outfitsStream,
              builder: (context, snapshot) {
                final outfits = snapshot.data ?? const <Outfit>[];

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (outfits.isEmpty) {
                  return Center(
                    child: Text(
                      'No outfits yet',
                      style: textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: outfits.length,
                  itemBuilder: (context, index) {
                    final outfit = outfits[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: OutfitItem(
                        outfit: outfit,
                        draggable: true,
                        compact: false,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
