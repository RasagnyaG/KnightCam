// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomImageButton extends StatelessWidget {
  dynamic url;
  double? size;
  final Function onPressed;
  CustomImageButton({Key? key, this.url, this.size, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    size ??= 40;
    if (url != null) {
      return GestureDetector(
          onTap: () => onPressed(),
          child: CircleAvatar(
            radius: size,
            backgroundImage: NetworkImage(url),
          ));
    }
    return GestureDetector(
        onTap: () => onPressed(),
        child: CircleAvatar(
          radius: size,
          backgroundImage: const AssetImage("assets/Person.webp"),
        ));
  }
}
