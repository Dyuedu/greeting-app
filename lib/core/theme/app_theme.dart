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
        iconTheme: const IconThemeData(color: Colors.yellow, size: 24),
        titleTextStyle: const TextStyle(
          color: Colors.yellow,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
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
        margin: const EdgeInsets.all(0),
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
        dense: false,
        minVerticalPadding: 10,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: TetColors.luckyRed, size: 24),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: TetColors.darkRed,
          fontSize: 40,
          fontWeight: FontWeight.w700,
          height: 1.15,
          letterSpacing: 0.2,
        ),
        displayMedium: TextStyle(
          color: TetColors.darkRed,
          fontSize: 34,
          fontWeight: FontWeight.w700,
          height: 1.18,
        ),
        displaySmall: TextStyle(
          color: TetColors.darkRed,
          fontSize: 28,
          fontWeight: FontWeight.w600,
          height: 1.2,
        ),
        headlineLarge: TextStyle(
          color: TetColors.luckyRedDark,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          height: 1.22,
        ),
        headlineMedium: TextStyle(
          color: TetColors.luckyRedDark,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          height: 1.25,
        ),
        titleLarge: TextStyle(
          color: TetColors.luckyRedDark,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          height: 1.25,
        ),
        titleMedium: TextStyle(
          color: TetColors.luckyRedDark,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
        titleSmall: TextStyle(
          color: TetColors.luckyRedDark,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
        bodyLarge: TextStyle(
          color: TetColors.darkRed,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.45,
        ),
        bodyMedium: TextStyle(
          color: TetColors.darkRed,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.45,
        ),
        bodySmall: TextStyle(
          color: TetColors.luckyRedDark,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.35,
        ),
        labelLarge: TextStyle(
          color: TetColors.luckyRedDark,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
        labelMedium: TextStyle(
          color: TetColors.luckyRedDark,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        labelSmall: TextStyle(
          color: TetColors.luckyRedDark,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
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

      dialogTheme: DialogThemeData(
        titleTextStyle: const TextStyle(
          color: TetColors.darkRed,
          fontSize: 19,
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle: const TextStyle(
          color: TetColors.luckyRedDark,
          fontSize: 14,
          height: 1.45,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: TetColors.warmWhite,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
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
