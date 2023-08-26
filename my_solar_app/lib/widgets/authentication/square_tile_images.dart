import 'package:flutter/material.dart';


class SquareImageTile extends StatelessWidget{
  final String imagePath;

  const SquareImageTile({
    super.key,
    required this.imagePath,
});

  @override
  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.all(12),
      decoration:
      BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child:
        Image.asset(
          imagePath,
          scale:9
        )
    );

  }
}