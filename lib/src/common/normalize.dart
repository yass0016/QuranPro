import 'package:flutter/material.dart';

class Normalize {
  static const double baseUnitWidth = 411;
  static const double baseUnitHeight = 731;

  static double normalizeWidth(BuildContext context, double width) {
    MediaQueryData queryData = MediaQuery.of(context);

    return (width / baseUnitWidth) * queryData.size.width;
  }

  static double normalizeHeight(BuildContext context, double height) {
    MediaQueryData queryData = MediaQuery.of(context);

    return (height / baseUnitHeight) * queryData.size.height;
  }
}