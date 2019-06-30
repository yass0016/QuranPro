import 'package:flutter/material.dart';

class Normalize {
  static const double baseUnitWidth = 411;
  static const double baseUnitHeight = 731;

  static double normalizeWidth(BuildContext context, double width) {
    MediaQueryData queryData = MediaQuery.of(context);

    double normalize = (queryData.orientation == Orientation.portrait) ? baseUnitWidth : baseUnitHeight;

    return (width / normalize) * queryData.size.width;
  }

  static double normalizeHeight(BuildContext context, double height) {
    MediaQueryData queryData = MediaQuery.of(context);

    double normalize = (queryData.orientation == Orientation.portrait) ? baseUnitHeight : baseUnitWidth;

    return (height / normalize) * queryData.size.height;
  }
}