import 'package:flutter/material.dart';

class AppTheme {
  // Primary gradient colors
  static const Color primaryGradientStart = Color(0xFF1E8C6E);
  static const Color primaryGradientEnd = Color(0xFF00796B);
  
  // Secondary gradient colors
  static const Color secondaryGradientStart = Color(0xFF26A69A);
  static const Color secondaryGradientEnd = Color(0xFF00897B);
  
  // Accent color for highlights
  static const Color accentColor = Color(0xFFB2DFDB);
  
  // Background colors
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Colors.white;
  
  // Text colors
  static const Color primaryTextColor = Color(0xFF212121);
  static const Color secondaryTextColor = Color(0xFF757575);
  
  // Button styles
  static ButtonStyle elevatedButtonStyle({bool isPrimary = true}) {
    return ButtonStyle(
      elevation: MaterialStateProperty.resolveWith<double>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) return 2;
          if (states.contains(MaterialState.hovered)) return 4;
          return 3;
        },
      ),
      backgroundColor: MaterialStateProperty.all(Colors.transparent),
      foregroundColor: MaterialStateProperty.all(Colors.white),
      padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      overlayColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.white.withOpacity(0.1);
          }
          return null;
        },
      ),
    );
  }
  
  // Text button style
  static ButtonStyle textButtonStyle() {
    return ButtonStyle(
      foregroundColor: MaterialStateProperty.all(primaryGradientStart),
      overlayColor: MaterialStateProperty.all(primaryGradientStart.withOpacity(0.1)),
      textStyle: MaterialStateProperty.all(
        const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  // Gradient decoration for buttons
  static Decoration primaryGradientDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [primaryGradientStart, primaryGradientEnd],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: primaryGradientEnd.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
  
  static Decoration secondaryGradientDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [secondaryGradientStart, secondaryGradientEnd],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: secondaryGradientEnd.withOpacity(0.3),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
  
  // Custom theme data
  static ThemeData themeData() {
    return ThemeData(
      primarySwatch: Colors.teal,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGradientStart,
        primary: primaryGradientStart,
        secondary: secondaryGradientStart,
        background: backgroundColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      cardTheme: const CardTheme(
        color: cardColor,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: textButtonStyle(),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryGradientStart,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryGradientStart.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryGradientStart.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryGradientStart, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      useMaterial3: true,
    );
  }
}

// Custom gradient button widget
class GradientButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final double height;
  final double? width;
  final EdgeInsetsGeometry padding;

  const GradientButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.isPrimary = true,
    this.height = 50,
    this.width,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: isPrimary
          ? AppTheme.primaryGradientDecoration()
          : AppTheme.secondaryGradientDecoration(),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: padding,
        ),
        child: child,
      ),
    );
  }
}
