import 'package:flutter/material.dart';

class MinorTickStyle {
  final int length;
  final double thickness;
  final Color color;
  final Color highlightColor;

  const MinorTickStyle({
    this.length = 7,
    this.thickness = 6,
    this.color = Colors.transparent,
    this.highlightColor = Colors.green,
  });
}
