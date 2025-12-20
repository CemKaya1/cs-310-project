import 'package:cs_310_project/models/item_doc_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cs_310_project/views/my_closet/closet_provider.dart';
import 'package:cs_310_project/widgets/closet_item.dart';

class MyClosetPage extends StatefulWidget {
  const MyClosetPage({super.key});

  @override
  State<MyClosetPage> createState() => _MyClosetPageState();
}

class _MyClosetPageState extends State<MyClosetPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80, bottom: 20),
            child: Center(
              child: Text(
                "My Closet",
                style: TextStyle(
                  fontSize: 24,
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            // Listen to the stream from Provider
            child: StreamBuilder<List<ItemDoc>>(
              stream: context.read<ClosetProvider>().itemsStream,
              builder: (context, snapshot) {
                // 1. Loading State
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // 2. Error State
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                // 3. Data Check
                final items = snapshot.data ?? [];

                if (items.isEmpty) {
                  return Center(
                    child: Text(
                      "No items in closet yet.",
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                  );
                }

                // 4. List Display
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final ItemDoc item = items[index];
                    
                    // Determine image path (Network or Local asset fallback)
                    // If your ItemDoc stores downloadUrl in 'imageUrl', use that.
                    // If it's a mock item without URL, it might be empty.
                    final displayImage = (item.imageUrl.isNotEmpty) 
                        ? item.imageUrl 
                        : "lib/core/mock/mock_images/white_placeholder.png"; 

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          // Pass the entire ItemDoc object to the detail page
                          Navigator.pushNamed(
                            context,
                            "/item_detail",
                            arguments: item,
                          );
                        },
                        child: ClosetItem(
                          name: item.name,
                          imagePath: displayImage,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.pushNamed(context, "/item_creator");
          if (created == true && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Item added successfully")),
            );
          }
        },
        backgroundColor: colorScheme.inverseSurface,
        foregroundColor: colorScheme.onInverseSurface,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}