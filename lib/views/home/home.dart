import 'package:flutter/material.dart';

class OutlifyHome extends StatelessWidget {
  const OutlifyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Outfitly Home"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Navigation Test Buttons',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // ---- EXISTING BUTTONS ----
              const Text('Go to My Closet'),
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 12),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/my_closet");
                  },
                  child: const Text("My Closet"),
                ),
              ),

              const Text('Go to Item Detail'),
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 12),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/item_detail");
                  },
                  child: const Text("Item Detail"),
                ),
              ),

              const Text('Go to Outfit Detail'),
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 12),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/outfit_detail");
                  },
                  child: const Text("Outfit Detail"),
                ),
              ),

              const Text('Go to Planner'),
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 12),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/planner");
                  },
                  child: const Text("Planner"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
