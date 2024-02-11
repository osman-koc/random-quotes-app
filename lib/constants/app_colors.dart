import 'dart:math';

import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class AppColors {
  final BuildContext context;
  final Random _random;

  AppColors(this.context) : _random = Random();

  bool get isDarkMode {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Color get tdBlue => Colors.blue;

  Color get popupSelectedBg => Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7);

  static Color bgColorLastSelect = Vx.gray800;
  int get bgColorLength => bgColors.length;
  List<Color> get bgColors => [
        Vx.gray800,
        Vx.red800,
        Vx.blue800,
        Vx.green800,
        Vx.teal800,
        Vx.purple800,
        Vx.pink800,
        Vx.orange800,
      ];
  Color get bgRandomColor {
    var selectedColor = bgColors[_random.nextInt(bgColorLength)];
    while (selectedColor == bgColorLastSelect){
      selectedColor = bgColors[_random.nextInt(bgColorLength)];
    }
    bgColorLastSelect = selectedColor;
    return selectedColor;
  }
}
