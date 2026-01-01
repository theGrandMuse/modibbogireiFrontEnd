import 'package:modibbogirei/features/providers/login_provider.dart';
import 'package:modibbogirei/features/services/navigator_service.dart';
import 'package:modibbogirei/routes/routes.dart';
import 'package:modibbogirei/utils/device/device_utility.dart';
import 'package:modibbogirei/utils/popups/loaders.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';

class MenuProviderNotifier extends StateNotifier<String?> {
  MenuProviderNotifier(this.ref) : super(null);

  Ref ref;

  String activeItem = '';
  String hoverItem = '';

  void changeActiveItem(String route) {
    activeItem = ref.read(activeItemProvider) ?? TRoutes.dashboard;
    activeItem = route;
    ref.read(activeItemProvider.notifier).state = activeItem;
  }

  void changeHoverItem(String route) {
    if (!isActive(route)) {
      hoverItem = ref.read(hoverItemProvider) ?? '';

      hoverItem = route;
      ref.read(hoverItemProvider.notifier).state = hoverItem;
    }
  }

  bool isActive(String route) => activeItem == route;
  bool isHovering(String route) => hoverItem == route;

  Future<void> menuOnTap(String route) async {
    BuildContext context = NavigationService.navigatorKey.currentContext!;
    try {
      if (!isActive(route)) {
        changeActiveItem(route);
        if (TDeviceUtils.isMobileScreen) context.pop();

        if (route == '/logout') {
          state = null;
          ref.read(loginProvider.notifier).logout();
          context.go(TRoutes.login);
        } else {
          state = route;
          context.go(route);
        }
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error');
    }
  }
}

final menuProvider =
    StateNotifierProvider<MenuProviderNotifier, String?>((ref) {
  return MenuProviderNotifier(ref);
});
final activeItemProvider = StateProvider<String?>((ref) => null);
final hoverItemProvider = StateProvider<String?>((ref) => null);
