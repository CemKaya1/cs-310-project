import 'package:cs_310_project/core/mock/mock_items.dart';
import 'package:cs_310_project/views/item_detail/item_detail_page.dart';
import 'package:cs_310_project/widgets/closet_item.dart';
import 'package:flutter/material.dart';

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
      // Use theme background 
      backgroundColor: theme.scaffoldBackgroundColor,
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 120),
              child: Center(
                child: Text(
                  "MyCloset Page",
                  style: TextStyle(
                    fontSize: 24,
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold, 
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
                itemCount: MockItems.list.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async {
                        final deleted = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ItemDetailPage(
                              name: MockItems.list[index].name,
                              image: MockItems.list[index].imagePath,
                              index: index,
                            ),
                          ),
                        );
                        if (deleted == true && mounted) {
                          setState(() {}); // rebuild to reflect deletion
                        }
                      },
                      child: ClosetItem(
                        name: MockItems.list[index].name,
                        imagePath: MockItems.list[index].imagePath,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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