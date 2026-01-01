import 'package:another_flushbar/flushbar.dart';
import 'package:modibbogirei/features/services/navigator_service.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../constants/colors.dart';
import '../helpers/helper_functions.dart';

class TLoaders {

  static dynamic hideSnackBar() =>
      ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!).hideCurrentSnackBar();

  static dynamic customToast({required dynamic message}) {
    ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        width: 500,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.all(12.0),
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: THelperFunctions.isDarkMode(NavigationService.navigatorKey.currentContext!)
                ? TColors.darkerGrey.withAlpha(90)
                : TColors.grey.withAlpha(90),
          ),
          child: Center(
              child: Text(message,
                  style: Theme.of(NavigationService.navigatorKey.currentContext!).textTheme.labelLarge)),
        ),
      ),
    );
  }

  static dynamic customToastInternet({required dynamic message}) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      message: message,
      messageColor: TColors.black,
      margin: EdgeInsets.all(20),
      backgroundColor: const Color.fromARGB(255, 188, 240, 173),
      duration: Duration(seconds: 1),
      icon: Icon(
        Iconsax.cloud_connection,
        color: TColors.darkGreenColor,
      ),
    ).show(NavigationService.navigatorKey.currentContext!);
    /* ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        // width: 500,
        margin: const EdgeInsets.only(bottom: 180.0, left: 20.0, right: 20.0),
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.all(12.0),
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: THelperFunctions.isDarkMode(Get.context!)
                ? Colors.lightGreen.withAlpha(90)
                : Colors.lightGreen.withAlpha(90),
          ),
          child: Center(
              child: Text(message,
                  style: Theme.of(Get.context!).textTheme.labelLarge)),
        ),
      ), 
    );
      */
  }

  static dynamic customToastNoInternet({required dynamic message}) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      message: message,
      messageColor: TColors.black,
      margin: EdgeInsets.all(20),
      backgroundColor: const Color.fromARGB(255, 240, 173, 179),
      duration: Duration(seconds: 1),
      icon: Icon(
        Iconsax.cloud_connection,
        color: TColors.redColor,
      ),
    ).show(NavigationService.navigatorKey.currentContext!);

    /* ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        // width: 500,
        margin: const EdgeInsets.only(bottom: 300.0, left: 20.0, right: 20.0),
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.all(12.0),
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: THelperFunctions.isDarkMode(Get.context!)
                ? Color.fromARGB(0, 236, 165, 165).withAlpha(90)
                : Color.fromARGB(0, 236, 165, 165).withAlpha(90),
          ),
          child: Center(
              child: Text(message,
                  style: Theme.of(Get.context!).textTheme.labelLarge)),
        ),
      ),
    ); */
  }

  static dynamic successSnackBar({required dynamic title, duration = 2}) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      message: title.toString().toUpperCase(),
      messageSize: 25,
      maxWidth: 250,
      messageColor: TColors.white,
      margin: EdgeInsets.all(10),
      backgroundColor: TColors.successColor,
      duration: Duration(seconds: 1),
      icon: Icon(
        Icons.verified_outlined,
        color: TColors.white,
      ),
    ).show(NavigationService.navigatorKey.currentContext!);
  }

  


  static dynamic errorSnackBar({required dynamic title, message = ''}) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      message: title,
      maxWidth: 400,
      messageColor: TColors.white,
      margin: EdgeInsets.all(20),
      backgroundColor: TColors.dangerColor,
      duration: Duration(seconds: 1),
      icon: Icon(
        Icons.cancel,
        color: TColors.white,
      ),
    ).show(NavigationService.navigatorKey.currentContext!);
  }
}
