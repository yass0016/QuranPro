import 'package:quranpro/src/common/normalize.dart';
import 'package:flutter/material.dart';

class Style {
  static double textSize(BuildContext context, double size) {
    return Normalize.normalizeHeight(context, size);
  }

  static double iconSize(BuildContext context, double size) {
    return Normalize.normalizeHeight(context, size);
  }
}