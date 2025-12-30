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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        title: Text(
          "My Closet",
          style: TextStyle(
            fontSize: 24,
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            // StreamBuilder keeps the UI in sync with the database in real-time
            child: StreamBuilder<List<ItemDoc>>(
              stream: context.read<ClosetProvider>().itemsStream,
              builder: (context, snapshot) {
                // Handle the initial connection state
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Display error message if the stream fails
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                final items = snapshot.data ?? [];

                // Handle empty state (e.g., first-time users)
                if (items.isEmpty) {
                  return Center(
                    child: Text(
                      "No items in closet yet.",
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final ItemDoc item = items[index];

                    // Prioritize network URLs; fallback to local asset if null/empty
                    final displayImage = (item.imageUrl.isNotEmpty) 
                        ? item.imageUrl 
                        : "lib/core/mock/mock_images/white_placeholder.png"; 

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          // Pass the specific item instance to the detail page via arguments
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
          // Wait for the result from ItemCreator to see if a new item was actually added
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
