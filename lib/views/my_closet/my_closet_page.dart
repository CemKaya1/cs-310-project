import 'package:cs_310_project/core/mock/mock_items.dart';
import 'package:cs_310_project/widgets/closet_item.dart';
import 'package:flutter/material.dart';

class MyClosetPage extends StatelessWidget {
  const MyClosetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      /*
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("MyCloset Page"),
      ),*/
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 120),
            child: Center(child: Text("MyCloset Page",style: TextStyle(fontSize: 24),),),
          ),
          Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
                  itemCount: MockItems.list.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClosetItem(name: MockItems.list[index].name ,imagePath: MockItems.list[index].imagePath),
                    );
                  },
                ),
              ),
          
          ],
          ),
      ),
        floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add item logic here
          print('Add button pressed');
        },
        backgroundColor: Colors.black, // Dark background for the FAB
        foregroundColor: Colors.white, // White plus icon
        shape: const CircleBorder(), // Ensure it's circular
        child: const Icon(Icons.add),
      ),
    );
  }
}