import 'package:flutter/material.dart';


class OutlifyHome extends StatelessWidget {
  const OutlifyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Outlify Home Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text('Go to my closet page'),
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 12),
              child: ElevatedButton(onPressed: (){
              
                Navigator.pushNamed(context, "/my_closet");
              }, child: Text("Go to MyCloset"),),
            ),    const Text('Go to item detail page'),
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 12),
              child: ElevatedButton(onPressed: (){
                Navigator.pushNamed(context, "/item_detail");
              }, child: Text("Go to Item Detail"),),
            ),
          ],
        ),
      ),
    
    );
  }
}

