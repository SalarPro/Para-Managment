import 'package:flutter/material.dart';

class SPColors {
  static Color mainColor = Color.fromARGB(255, 61, 106, 230);
  static Color mainColor2 = Color.fromARGB(255, 10, 57, 184);
  static Color background = Color.fromARGB(255, 247, 247, 247);

  static Color whiteColor = Colors.white;
  static Color selectedColor = Color(0xff9D9D9D);
  static Color blackColor = Colors.black;
  static Color backGroundColor = Color.fromARGB(255, 250, 250, 250);
  static Color greyText = Colors.grey.shade700;
  static Color blueColor = Color.fromARGB(255, 10, 57, 184);

  static Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}
