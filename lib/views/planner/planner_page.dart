import 'package:flutter/material.dart';
import 'package:cs_310_project/core/constants/app_text_styles.dart';
import 'package:cs_310_project/core/mock/mock_outfits.dart';
import 'package:cs_310_project/widgets/bottom_nav_bar.dart';

class PlannerPage extends StatefulWidget {
  const PlannerPage({super.key});

  @override
  State<PlannerPage> createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> {
  final List<String?> assignedOutfits = List.filled(28, null);

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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // === Takvim başlık satırı ===
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: days
                      .map((d) => Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ))
                      .toList(),
                ),
                const SizedBox(height: 8),

                // === Takvim 4x7 kareler ===
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
                    final assigned = assignedOutfits[index];

                    return DragTarget<String>(
                      onAccept: (outfitName) {
                        setState(() {
                          assignedOutfits[index] = outfitName;
                        });
                      },
                      builder: (context, candidateData, rejectedData) {
                        return Container(
                          decoration: BoxDecoration(
                            color: candidateData.isNotEmpty
                                ? Colors.deepPurple.shade50
                                : Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              assigned ?? "",
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 16),
                Text("Saved Outfits", style: AppTextStyles.title),
                const SizedBox(height: 8),

                // === Saved Outfits listesi (dikey kaydırılabilir) ===
                SizedBox(
                  height: 300, // alt liste yüksekliği
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: mockOutfits.length,
                    itemBuilder: (context, index) {
                      final outfit = mockOutfits[index];
                      return Draggable<String>(
                        data: outfit.name,
                        feedback: Material(
                          color: Colors.transparent,
                          child: _buildOutfitCard(
                            outfit.name,
                            imageUrl: outfit.imageUrl,
                            dragging: true,
                          ),
                        ),
                        childWhenDragging: _buildOutfitCard(
                          outfit.name,
                          imageUrl: outfit.imageUrl,
                          opacity: 0.4,
                        ),
                        child: _buildOutfitCard(
                          outfit.name,
                          imageUrl: outfit.imageUrl,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const OutfitlyBottomNavBar(currentIndex: 2),
    );
  }

  // === Outfit Kartı ===
  Widget _buildOutfitCard(
      String name, {
        String? imageUrl,
        bool dragging = false,
        double opacity = 1,
      }) {
    return Opacity(
      opacity: opacity,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: dragging ? Colors.deepPurple.shade100 : Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imageUrl != null
                ? Image.network(
              imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
              const Icon(Icons.image_not_supported, size: 40),
            )
                : const Icon(Icons.image, size: 40, color: Colors.grey),
          ),
          title: Text(name, style: const TextStyle(fontSize: 16)),
          trailing: const Icon(Icons.drag_handle),
        ),
      ),
    );
  }
}
