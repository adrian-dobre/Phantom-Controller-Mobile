import 'package:flutter/material.dart';

Color? getCO2IndicatorColor(int? value) {
  if (value == null) {
    return null;
  }
  Color color;
  if (value > 2000) {
    color = Colors.red;
  } else if (value > 1500) {
    color = Colors.orange;
  } else if (value > 1000) {
    color = Colors.yellow;
  } else if (value > 600) {
    color = Colors.lightGreen;
  } else {
    color = Colors.green;
  }
  return color;
}

Color? getHumidityIndicatorColor(double? value) {
  if (value == null) {
    return null;
  }
  Color color;
  if (value > 70) {
    color = Colors.blue;
  } else if (value > 40) {
    color = Colors.green;
  } else {
    color = Colors.white;
  }
  return color;
}

Color? getTemperatureIndicatorColor(double? value) {
  if (value == null) {
    return null;
  }
  Color color;
  if (value > 30) {
    color = Colors.red;
  } else if (value > 26) {
    color = Colors.orange;
  } else if (value > 23) {
    color = Colors.yellow;
  } else if (value > 20) {
    color = Colors.green;
  } else {
    color = Colors.blue;
  }
  return color;
}

Color themeColorGradientStart = const Color(0xFF1c1f38);
Color themeColorGradientEnd = const Color(0xff101428);
