import 'package:flutter/rendering.dart';
import 'dart:io';

void enableDebug(bool enable) {
  debugPaintSizeEnabled = enable;
  debugPaintPointersEnabled = enable;
  debugPaintBaselinesEnabled = enable;
  debugPaintLayerBordersEnabled = enable;
  debugRepaintRainbowEnabled = enable;
}

void toggleDebug() {
  debugPaintSizeEnabled = !debugPaintSizeEnabled;
  debugPaintPointersEnabled = !debugPaintPointersEnabled;
  debugPaintBaselinesEnabled = !debugPaintBaselinesEnabled;
  debugPaintLayerBordersEnabled = !debugPaintLayerBordersEnabled;
  debugRepaintRainbowEnabled = !debugRepaintRainbowEnabled;
}

bool isMobile() {
  return Platform.isAndroid || Platform.isIOS || Platform.isFuchsia;
}

bool isDesktop() {
  return Platform.isLinux || Platform.isMacOS || Platform.isWindows;
}

bool isWeb() {
  return !isMobile() && !isDesktop();
}