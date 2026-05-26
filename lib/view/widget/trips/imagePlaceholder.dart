import 'package:flutter/material.dart';

class ImagePlaceHolder extends StatelessWidget {
  const ImagePlaceHolder({super.key, required this.width, required this.height});
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      color: Colors.white10,
      child: const Icon(Icons.directions_car, color: Colors.white, size: 45),
    );
  }
}
