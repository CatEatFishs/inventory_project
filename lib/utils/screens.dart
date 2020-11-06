import 'package:flutter/material.dart';


class AdaptUtils {
  static double _screenWidth = 1080;

  static double _screenHeight = 1920;

  static double _widthRatio;
  static double _textScaleFactor;

  static double designWidth = 750;
  static double designHeight = 1334;

  static init(double uiWidth, double uiHeight) {
    designWidth = uiWidth;
    designHeight = uiHeight;

    double devicePixelRatio = WidgetsBinding.instance.window.devicePixelRatio;
    double physicalSizeWidth = WidgetsBinding.instance.window.physicalSize.width;
    double physicalSizeHeight = WidgetsBinding.instance.window.physicalSize.height;

    _textScaleFactor = WidgetsBinding.instance.window.textScaleFactor;

//    _screenWidth = physicalSizeWidth ;
//    _screenHeight = physicalSizeHeight ;
    _screenWidth = physicalSizeWidth / devicePixelRatio;
    _screenHeight = physicalSizeHeight / devicePixelRatio;

    _widthRatio = _screenWidth / designWidth;

  }

  ///高度的适配
  static double pxH(number) {
    return number * _widthRatio;
  }

  ///宽度的适配
  static double pxW(number) {
    return number * _widthRatio;
  }

  ///字体的适配
  static double pxF(number) {
    return pxW(number) / _textScaleFactor;
  }

  static double screenW() {
    return _screenWidth;
  }

  static double screenH() {
    return _screenHeight;
  }
}
double getScreenWidth()=>AdaptUtils.screenW();

double getScreenHeight()=>AdaptUtils.screenH();

double setWidth(double size) =>AdaptUtils.pxW(size);

double setHeight(double size) =>AdaptUtils.pxH(size);

double setSp(double size) =>AdaptUtils.pxF(size);