import 'package:flutter/material.dart';
import '../../../../../utils/constants/colors.dart';
import 'login_form_desktop.dart';

class LoginScreenDesktop extends StatelessWidget {
  const LoginScreenDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    //final controller = Get.put(LoginController());
    return Center(
      child: SizedBox(
        height: 600,
        width: 1100,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: TColors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: TColors.white),
              boxShadow: [
                BoxShadow(
                  color: TColors.grey.withValues(alpha: 0.9),
                  spreadRadius: 5,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                LoginFormDesktopLeftSide(),
                LoginFormDesktopRightSide(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
