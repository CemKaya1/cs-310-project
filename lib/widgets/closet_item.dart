import 'package:flutter/material.dart';

class ClosetItem extends StatelessWidget {
  final String imagePath;
  final String name;

  const ClosetItem({super.key, required this.imagePath,required this.name,});


  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context); 

  final double screenWidth = screenSize.width;
  final double screenHeight = screenSize.height;
    return  Container(
      decoration: BoxDecoration(border: Border.all(width: 0.5,color: Colors.black),borderRadius: BorderRadius.all(Radius.circular(12))),
      width: screenWidth/2,
      height: screenHeight/8,
      child: Row(
        children: [
          
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(imagePath),
          ),
        Padding(padding: EdgeInsetsGeometry.all(2),child: Text(name,style: TextStyle(fontSize: 18),),)
        
        ],
      
      ),
    );
  }
}