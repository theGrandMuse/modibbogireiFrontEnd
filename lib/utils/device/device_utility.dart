import 'dart:io';

import 'package:modibbogirei/features/services/navigator_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

import '../constants/sizes.dart';

class TDeviceUtils {


  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static Future<void> setStatusBarColor(Color color) async {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: color),
    );
  }

static   bool get isLandscapeOrientation {
    BuildContext  context = NavigationService.navigatorKey.currentContext!;

    final viewInsets = View.of(context).viewInsets;
    return viewInsets.bottom == 0;
  }

static   bool get isPortraitOrientation {
    BuildContext  context = NavigationService.navigatorKey.currentContext!;

    final viewInsets = View.of(context).viewInsets;
    return viewInsets.bottom != 0;
  }

  static void setFullScreen(bool enable) {
  
    SystemChrome.setEnabledSystemUIMode(enable ? SystemUiMode.immersiveSticky : SystemUiMode.edgeToEdge);
  }

 static  double get screenHeight {
    BuildContext  context = NavigationService.navigatorKey.currentContext!;

    return MediaQuery.of(context).size.height;
  }

 static  double get screenWidth {
    BuildContext  context = NavigationService.navigatorKey.currentContext!;

    return MediaQuery.of(context).size.width;
  }

 static  double  get pixelRatio {
    BuildContext  context = NavigationService.navigatorKey.currentContext!;

    return MediaQuery.of(context).devicePixelRatio;
  }

 static  double get  statusbarHeight {
    BuildContext  context = NavigationService.navigatorKey.currentContext!;

    return MediaQuery.of(context).padding.top;
  }

 static  double get  bottomNavigationBarHeight {
    return kBottomNavigationBarHeight;
  }

  static double get getAppBarHeight {
    return kToolbarHeight;
  }

 static  double get keyboardHeight {
    BuildContext  context = NavigationService.navigatorKey.currentContext!;

    final viewInsets = MediaQuery.of(context).viewInsets;
    return viewInsets.bottom;
  }

 static  Future<bool> get isKeyboardVisible async {
    BuildContext  context = NavigationService.navigatorKey.currentContext!;

    final viewInsets = View.of(context).viewInsets;
    return viewInsets.bottom > 0;
  }

 static  Future<bool> get isPhysicalDevice async {
    return defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;
  }

  static void vibrate(Duration duration) {
    HapticFeedback.vibrate();
    Future.delayed(duration, () => HapticFeedback.vibrate());
  }

  static Future<void> setPreferredOrientations(List<DeviceOrientation> orientations) async {
    await SystemChrome.setPreferredOrientations(orientations);
  }

  static void hideStatusBar() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  static void showStatusBar() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  }

  static Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

 static  bool get isIOS {
    return Platform.isIOS;
  }

 static  bool get isMacOS {
    return Platform.isMacOS;
  }

 static  bool get isAndroid {
    return Platform.isAndroid;
  }

  static bool get isDesktopScreen {
      BuildContext  context = NavigationService.navigatorKey.currentContext!;

    return MediaQuery.of(context).size.width >= TSizes.desktopScreenSize;
  }

  static bool get isTabletScreen {
      BuildContext  context = NavigationService.navigatorKey.currentContext!;

    return MediaQuery.of(context).size.width >= TSizes.tabletScreenSize && MediaQuery.of(context).size.width < TSizes.desktopScreenSize;
  }

  static bool get isMobileScreen{
      BuildContext  context = NavigationService.navigatorKey.currentContext!;

    return MediaQuery.of(context).size.width < TSizes.tabletScreenSize;
  }
}
