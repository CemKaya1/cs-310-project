import 'package:flutter/material.dart';
import 'package:cs_310_project/core/constants/app_text_styles.dart';
import 'package:cs_310_project/core/mock/mock_outfits.dart';

class OutfitDetailPage extends StatelessWidget {
  const OutfitDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final outfit = mockOutfits.first; // mock data

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          // MyOutfits rotasına geri dön
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              "/my_outfits",
                  (route) => false,
            );
          },
        ),
        title: const Text("Outfit Detail"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.image, size: 100, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),
            Text("Included Items", style: AppTextStyles.title),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: outfit.items.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(outfit.items[index]),
                      trailing: const Icon(Icons.check_circle_outline),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit"),
                ),
                ElevatedButton.icon(
                  style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  onPressed: () {},
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
