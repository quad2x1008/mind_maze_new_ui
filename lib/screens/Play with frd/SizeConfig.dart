import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static double screenWidth = 0.0;
  static double screenHeight = 0.0;
  static double? devicePixelRatio;
  static double? blockSizeHorizontal;
  static double? blockSizeVertical;

  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static double? safeBlockHorizontal;
  static double? safeBlockVertical;
  static double? statusBarHeight;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    devicePixelRatio = _mediaQueryData.devicePixelRatio;
    statusBarHeight = MediaQuery.of(context).padding.top;

    print(screenWidth.toString() + '==' + screenHeight.toString());
    blockSizeHorizontal = screenWidth! / 100;
    blockSizeVertical = screenHeight! / 100;

    _safeAreaHorizontal = _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical = _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth! - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight! - _safeAreaVertical) / 100;
  }
}

double calHeight(double size) {
  double px = (SizeConfig.screenHeight! / 896) * size;
  return px;
}

double calWidhth(double size) {
  double px = (SizeConfig.screenWidth! / 414) * size;

  return px;
}