import 'package:flutter/material.dart';

/// Brand palette for StampScaner — matches stampscaner.com.
/// Premium philatelic aesthetic: burgundy + cream + matte gold + ink black.
class AppColors {
  AppColors._();

  // Burgundy (primary)
  static const Color burgundy = Color(0xFF6B1F2E);
  static const Color burgundyDeep = Color(0xFF4D1520);
  static const Color burgundySoft = Color(0xFFC7807D);
  static const Color burgundyLight = Color(0xFFE5A8A5);

  // Gold (secondary, accent)
  static const Color gold = Color(0xFFB8924C);
  static const Color goldSoft = Color(0xFFD9B97A);
  static const Color goldDeep = Color(0xFF8A6B33);

  // Cream backgrounds (light theme)
  static const Color cream = Color(0xFFF8F2E4);
  static const Color creamElevated = Color(0xFFFFFFFF);
  static const Color creamDeep = Color(0xFFEFE6D2);

  // Ink (text)
  static const Color ink = Color(0xFF1A1410);
  static const Color inkSoft = Color(0xFF5A4A3A);
  static const Color inkMuted = Color(0xFF8A7660);

  // Borders
  static const Color border = Color(0xFFD9CCB1);
  static const Color borderSoft = Color(0xFFE8DDC4);

  // Dark theme companions
  static const Color darkBg = Color(0xFF1A1410);
  static const Color darkBgElevated = Color(0xFF221A14);
  static const Color darkBgDeep = Color(0xFF100B08);
  static const Color darkText = Color(0xFFF5EDDC);
  static const Color darkTextSoft = Color(0xFFC7B89A);
  static const Color darkBorder = Color(0xFF3A2D20);

  // Sepia theme companions
  static const Color sepiaBg = Color(0xFFEDE3D0);
  static const Color sepiaBgElevated = Color(0xFFF5ECD8);
  static const Color sepiaBgDeep = Color(0xFFE0D2B5);
  static const Color sepiaText = Color(0xFF3A2A18);
  static const Color sepiaBurgundy = Color(0xFF8A2A30);

  // Semantic
  static const Color success = Color(0xFF5E7C3F);
  static const Color warning = Color(0xFFB86A2C);
  static const Color danger = Color(0xFFA33124);
}
