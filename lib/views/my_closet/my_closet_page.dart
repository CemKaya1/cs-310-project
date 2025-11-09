import 'package:flutter/material.dart';

class MyClosetPage extends StatelessWidget {
  const MyClosetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("MyCloset Page"),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        
        
        
        
        Center(child: Text("MyCloset Page",style: TextStyle(fontSize: 24),))],),
    );
  }
}