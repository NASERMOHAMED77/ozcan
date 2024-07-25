import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_almirtech_ecommerce/utill/images.dart';

class CustomImage extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final Alignment? alignment;
  final String? placeholder;
  final bool isShow;

  const CustomImage(
      {super.key,
      required this.image,
      this.height,
      this.width,
      this.fit = BoxFit.contain,
      this.placeholder = Images.placeholder,
      this.alignment,
      this.isShow = true});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CachedNetworkImage(
          placeholder: (context, url) => Image.asset(
              placeholder ?? Images.placeholder,
              height: height,
              width: width,
              fit: BoxFit.contain),
          imageUrl: image,
          fit: fit ?? BoxFit.contain,
          height: height,
          width: width,
          alignment: alignment ?? Alignment.topCenter,
          errorWidget: (c, o, s) => Image.asset(
              placeholder ?? Images.placeholder,
              height: height,
              width: width,
              fit: BoxFit.cover),
        ),
      ],
    );
  }
}
