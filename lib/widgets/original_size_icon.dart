import 'package:flutter/material.dart';

/// A widget that displays the app icon at its original size without resizing
class OriginalSizeIcon extends StatelessWidget {
  final String iconPath;
  final BoxFit fit;

  /// Creates an OriginalSizeIcon widget
  /// 
  /// [iconPath] is the path to the icon asset (defaults to the app icon)
  /// [fit] determines how the image should be inscribed into the box
  const OriginalSizeIcon({
    Key? key,
    this.iconPath = 'assets/imges/icon.png',
    this.fit = BoxFit.none, // Use none to maintain original size
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      iconPath,
      fit: fit,
    );
  }
}
