import 'package:flutter/material.dart';

const Color kPrim = Color(0xFF6c63ff);
const Color kScaff = Color(0xFFF3F4F8);
const Color kSec = Color(0xFFE53F71);
const Color kOther = Color(0xFF59C1BD);
const Color kError = Color(0xFFE74C3C);
const Color kTextLight = Color(0xFFC5BDCD);
const Color kText = Color(0xFF3F0071);
const Color ringColor = Color(0xFFE5D1FA);
const Color bg = Color(0xFFE6E6FA);
const Color appBar = Color(0xFF3a0ca3);

hexStringToColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6)
  {
    hexColor = "FF"+hexColor;
  } 
  return Color(int.parse(hexColor,radix: 16));
}
