// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Ticketimage extends StatelessWidget {
  final String scr;
  final BoxFit? boxFit;
  final double? width;
  final double? height;
  const Ticketimage(
    {
      super.key,
      required this.scr,
      this.boxFit,
      this.height,
      this.width
      
    }
  );

  @override
  Widget build(BuildContext context) {
    return Image.network(
      scr,
      fit: boxFit,
      height: height,
      width: width,
      errorBuilder:(context, error, stackTrace) {
        return Icon(
          Icons.event_repeat_rounded,
          size: 30,
          color: Colors.black,
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if(loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null 
            ? 
            loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
          ),
        );
      },
    );
  }
}