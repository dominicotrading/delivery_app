import 'dart:ui';

import 'package:flutter/material.dart';

Size screenSize = MediaQueryData.fromView(window).size;
double titleFontSize = screenSize.width * 0.06;
double bodyFontSize = screenSize.width * 0.04;

final double physicalHeight =
    WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.height;
final double physicalWidth =
    WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width;

final double devicePixelRatio =
    WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
final double screenHeight = physicalHeight / devicePixelRatio;
final double screenWidth = physicalWidth / devicePixelRatio;


extension CapTitleExtension on String {
  String get titleCapitalizeString => this.split(" ").map((str) => str[0].toUpperCase() + str.substring(1)).join(" ");
}


String titleCase(String? text) {
  if (text == null) throw ArgumentError("string: $text");

  if (text.isEmpty) return text;

  return text
      .split(' ')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');
}