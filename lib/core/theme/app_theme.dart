import 'package:flutter/material.dart';
import 'package:greeting_app/core/theme/tet_colors.dart';

/// Tet-themed ThemeData configuration
class AppTheme {
  static ThemeData get tetTheme {
    return ThemeData(
      useMaterial3: true,

      // Color Scheme
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: TetColors.luckyRed,
        onPrimary: TetColors.prosperityGold,
        primaryContainer: TetColors.luckyRedLight,
        onPrimaryContainer: TetColors.darkRed,

        secondary: TetColors.prosperityGold,
        onSecondary: TetColors.luckyRedDark,
        secondaryContainer: TetColors.prosperityGoldLight,
        onSecondaryContainer: TetColors.darkRed,

        tertiary: TetColors.deepOrange,
        onTertiary: Colors.white,

        error: Colors.red.shade700,
        onError: Colors.white,
        errorContainer: Colors.red.shade100,
        onErrorContainer: Colors.red.shade900,

        surface: TetColors.warmWhite,
        onSurface: TetColors.darkRed,
        surfaceContainerHighest: TetColors.warmCream,
        onSurfaceVariant: TetColors.luckyRedDark,

        outline: TetColors.prosperityGoldDark,
        outlineVariant: TetColors.lightGold,

        shadow: Colors.black26,
        scrim: Colors.black54,
        inverseSurface: TetColors.luckyRedDark,
        onInverseSurface: TetColors.prosperityGoldLight,
        inversePrimary: TetColors.prosperityGold,

        surfaceTint: TetColors.luckyRed,
      ),

      // Scaffold Background
      scaffoldBackgroundColor: TetColors.warmWhite,

      // AppBar Theme - Red background with gold text/icons
      appBarTheme: AppBarTheme(
        backgroundColor: TetColors.luckyRed,
        foregroundColor: TetColors.prosperityGold,
        elevation: 4,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.yellow,
          size: 24,
        ),
        titleTextStyle: TextStyle(
          color: Colors.yellow,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),

      // Floating Action Button Theme - Gold background with red icon
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: TetColors.prosperityGold,
        foregroundColor: TetColors.luckyRedDark,
        elevation: 6,
        highlightElevation: 8,
        iconSize: 28,
      ),

      // Card Theme - Warm background with subtle gold border
      cardTheme: CardThemeData(
        color: TetColors.warmCream,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: TetColors.prosperityGold.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: TetColors.luckyRed,
          foregroundColor: TetColors.prosperityGold,
          elevation: 3,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: TetColors.luckyRed,
          side: BorderSide(color: TetColors.luckyRed, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: TetColors.luckyRed,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: TetColors.warmCream,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: TetColors.prosperityGold.withOpacity(0.5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: TetColors.prosperityGold.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: TetColors.prosperityGold,
            width: 2,
          ),
        ),
        labelStyle: TextStyle(color: TetColors.luckyRedDark),
        hintStyle: TextStyle(color: TetColors.luckyRedDark.withOpacity(0.6)),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: TetColors.lightGold,
        selectedColor: TetColors.prosperityGold,
        labelStyle: TextStyle(color: TetColors.luckyRedDark),
        secondaryLabelStyle: TextStyle(color: TetColors.luckyRedDark),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: TetColors.prosperityGold.withOpacity(0.3)),
        ),
      ),

      // ListTile Theme
      listTileTheme: ListTileThemeData(
        tileColor: TetColors.warmWhite,
        selectedTileColor: TetColors.prosperityGoldLight.withOpacity(0.3),
        iconColor: TetColors.luckyRed,
        textColor: TetColors.darkRed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: TetColors.luckyRed, size: 24),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: TetColors.darkRed,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: TetColors.darkRed,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: TetColors.darkRed,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: TetColors.luckyRedDark,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: TetColors.luckyRedDark,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(color: TetColors.darkRed),
        bodyMedium: TextStyle(color: TetColors.darkRed),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: TetColors.prosperityGold.withOpacity(0.3),
        thickness: 1,
        space: 1,
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: TetColors.luckyRedDark,
        contentTextStyle: const TextStyle(color: TetColors.prosperityGoldLight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static Widget get tetAppBarBackground {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background/tet-background.png'),
          fit: BoxFit.fill,
          opacity: 0.5,
        ),
      ),
    );
  }
}
