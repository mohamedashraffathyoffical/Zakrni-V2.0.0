import 'package:flutter/material.dart';

/// A custom widget for displaying the app icon with configurable size
class AppIconWidget extends StatelessWidget {
  final double size;
  final BoxFit fit;
  final String iconPath;

  /// Creates an AppIconWidget
  /// 
  /// [size] controls the width and height of the icon
  /// [fit] determines how the image should be inscribed into the box
  /// [iconPath] is the path to the icon asset (defaults to the app icon)
  const AppIconWidget({
    Key? key,
    this.size = 120.0, // Default to a larger size
    this.fit = BoxFit.contain,
    this.iconPath = 'assets/imges/icon.png',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        // Optional: add a subtle shadow for emphasis
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Image.asset(
          iconPath,
          width: size,
          height: size,
          fit: fit,
        ),
      ),
    );
  }
}

/// A hero version of the app icon widget for smooth transitions
class HeroAppIconWidget extends StatelessWidget {
  final double size;
  final BoxFit fit;
  final String iconPath;
  final String heroTag;

  /// Creates a HeroAppIconWidget for animated transitions between screens
  /// 
  /// [size] controls the width and height of the icon
  /// [fit] determines how the image should be inscribed into the box
  /// [iconPath] is the path to the icon asset (defaults to the app icon)
  /// [heroTag] is a unique identifier for the Hero animation
  const HeroAppIconWidget({
    Key? key,
    this.size = 120.0,
    this.fit = BoxFit.contain,
    this.iconPath = 'assets/imges/icon.png',
    required this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: AppIconWidget(
        size: size,
        fit: fit,
        iconPath: iconPath,
      ),
    );
  }
}

/// A responsive app icon that adjusts its size based on screen dimensions
class ResponsiveAppIconWidget extends StatelessWidget {
  final BoxFit fit;
  final String iconPath;
  final double widthFactor; // Percentage of screen width
  final double maxSize; // Maximum size constraint

  /// Creates a ResponsiveAppIconWidget that adapts to screen size
  /// 
  /// [fit] determines how the image should be inscribed into the box
  /// [iconPath] is the path to the icon asset (defaults to the app icon)
  /// [widthFactor] percentage of screen width (0.0 to 1.0)
  /// [maxSize] maximum size in logical pixels
  const ResponsiveAppIconWidget({
    Key? key,
    this.fit = BoxFit.contain,
    this.iconPath = 'assets/imges/icon.png',
    this.widthFactor = 0.3, // Default to 30% of screen width
    this.maxSize = 200.0, // Default maximum size
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate size based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final calculatedSize = screenWidth * widthFactor;
    
    // Use the smaller of calculated size or max size
    final finalSize = calculatedSize > maxSize ? maxSize : calculatedSize;
    
    return AppIconWidget(
      size: finalSize,
      fit: fit,
      iconPath: iconPath,
    );
  }
}
