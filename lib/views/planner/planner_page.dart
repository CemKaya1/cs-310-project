import 'package:flutter/material.dart';
import 'package:cs_310_project/core/constants/app_text_styles.dart';
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

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Planner"),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === GÜN BAŞLIKLARI ===
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: days
                    .map(
                      (d) => Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                )
                    .toList(),
              ),

              const SizedBox(height: 8),

              // === 4x7 GRID ===
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
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
                      return GestureDetector(
                        onTap: () {
                          setState(() => assignedOutfits[index] = null);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: candidate.isNotEmpty
                                ? Colors.deepPurple.shade50
                                : Colors.white,
                            border: Border.all(
                              color: Colors.grey.shade300,
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
              Text("Saved Outfits", style: AppTextStyles.title),
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
