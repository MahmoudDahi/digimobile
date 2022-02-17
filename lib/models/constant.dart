import 'dart:math';

import 'package:flutter/material.dart';

class Constant {
  final api2 = 'http://192.168.1.152/taxtechpre/v2/WEB';
  final api1 = 'http://192.168.1.152/taxtechpre/v1/WEB';
  final regex = RegExp(r'([.]*0)(?!.*\d)');

  Widget errorWidget(
    BuildContext context,
    String error,
  ) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).errorColor,
      padding: const EdgeInsets.all(8),
      child: Text(
        error,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  

  MaterialColor generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: tintColor(color, 0.9),
    100: tintColor(color, 0.8),
    200: tintColor(color, 0.6),
    300: tintColor(color, 0.4),
    400: tintColor(color, 0.2),
    500: color,
    600: shadeColor(color, 0.1),
    700: shadeColor(color, 0.2),
    800: shadeColor(color, 0.3),
    900: shadeColor(color, 0.4),
  });
}

int tintValue(int value, double factor) =>
    max(0, min((value + ((255 - value) * factor)).round(), 255));

Color tintColor(Color color, double factor) => Color.fromRGBO(
    tintValue(color.red, factor),
    tintValue(color.green, factor),
    tintValue(color.blue, factor),
    1);

int shadeValue(int value, double factor) =>
    max(0, min(value - (value * factor).round(), 255));

Color shadeColor(Color color, double factor) => Color.fromRGBO(
    shadeValue(color.red, factor),
    shadeValue(color.green, factor),
    shadeValue(color.blue, factor),
    1);
}
