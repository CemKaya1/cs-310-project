import 'package:flutter/material.dart';
import 'package:cs_310_project/core/mock/mock_outfits.dart';
import 'package:cs_310_project/models/outfit_model.dart';
import 'package:cs_310_project/widgets/outfit_item.dart';

class PlannerPage extends StatefulWidget {
  const PlannerPage({super.key});

  @override
  State<PlannerPage> createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> {
  // STATIC — sayfa değişince kaybolmaz
  static List<Outfit?> assignedOutfits = List.filled(28, null);

  @override
  Widget build(BuildContext context) {
    final days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
              // === DAY LABELS ===
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

              // === 4x7 GRID ===
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                ),

                itemCount: 28,

                itemBuilder: (context, index) {
                  final outfit = assignedOutfits[index];

                  return DragTarget<Outfit>(
                    onAccept: (value) {
                      setState(() {
                        assignedOutfits[index] = value;
                      });
                    },

                    builder: (context, candidate, rejected) {
                      final bool isHovering = candidate.isNotEmpty;

                      return GestureDetector(
                        onTap: () =>
                            setState(() => assignedOutfits[index] = null),

                        child: Container(
                          decoration: BoxDecoration(
                            color: isHovering
                                ? scheme.primaryContainer.withOpacity(0.4)
                                : scheme.surface,
                            border: Border.all(
                              color: scheme.outlineVariant,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),

                          padding: const EdgeInsets.all(3),

                          child: outfit == null
                              ? const SizedBox.shrink()
                              : OutfitItem(
                            outfit: outfit,
                            compact: true,
                          ),
                        ),
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

              // === DRAGGABLE OUTFIT LIST ===
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
                        draggable: true,
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
