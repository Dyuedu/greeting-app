import 'package:flutter/material.dart';

class GreetingTemplate {
  final String id;
  final String title;
  final String message;
  final String backgroundAssetPath;
  final Color textColor;
  final String fontFamily;
  final List<String> suggestedStickerPaths;

  const GreetingTemplate({
    required this.id,
    required this.title,
    required this.message,
    required this.backgroundAssetPath,
    required this.textColor,
    required this.fontFamily,
    required this.suggestedStickerPaths,
  });
}
