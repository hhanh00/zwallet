import 'package:flutter/material.dart';

final colors = [
  const Color(0xFF1DE9B6),
  const Color(0xFFCDDC39),
  const Color(0xFFAA00FF),
  const Color(0xFF2196F3),
  const Color(0xFF689F38),
  const Color(0xFF388E3C),
  const Color(0xFFF57C00),
  const Color(0xFFFFA000),
  const Color(0xFFFBC02D),
  const Color(0xFFFFEA00),
  const Color(0xFFE64A19),
  const Color(0xFF5D4037),
  const Color(0xFF7E57C2),
  const Color(0xFF2196F3),
  const Color(0xFFAA00FF),
  const Color(0xFF2196F3),
  const Color(0xFF00B0FF),
  const Color(0xFF00E5FF),
  const Color(0xFFAA00FF),
  const Color(0xFF2196F3),
  const Color(0xFF64DD17),
  const Color(0xFFAEEA00),
  const Color(0xFFAA00FF),
  const Color(0xFFFFAB00),
  const Color(0xFFAA00FF),
  const Color(0xFF2196F3),
];

final defaultColor = const Color(0xFF717171);

Color initialToColor(String s) {
  final i = s.toUpperCase().codeUnitAt(0);
  if (i >= 65 && i < 91) {
    return colors[i - 65];
  }
  return defaultColor;
}

Widget avatar(String initial) => CircleAvatar(
      backgroundColor: initialToColor(initial),
      child: Text(
        initial,
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      radius: 24.0,
    );
