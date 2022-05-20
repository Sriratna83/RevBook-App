import 'package:flutter/material.dart';

class ImageHandlerError extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  const ImageHandlerError(
      {required this.imageUrl, this.fit = BoxFit.cover, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      placeholder: const AssetImage("assets/images/placeholder.jpg"),
      image: NetworkImage(imageUrl),
      fit: fit,
    );
  }
}
