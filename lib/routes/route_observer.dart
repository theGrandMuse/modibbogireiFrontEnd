import 'package:modibbogirei/features/providers/menu_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'routes.dart';

final routeObserverProvider = Provider<RouteObservers>((ref) {
  return RouteObservers(ref);
});

class RouteObservers extends NavigatorObserver {
  Ref ref;
  RouteObservers(this.ref);
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      for (var routeName in TRoutes.sideMenuItems) {
        if (previousRoute.settings.name == routeName) {
        }
      }
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    for (var routeName in TRoutes.sideMenuItems) {
      if (route.settings.name == routeName) {
        //ref.read(activeItemProvider.notifier).state = routeName;
      }
    }
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    for (var routeName in TRoutes.sideMenuItems) {
      if (newRoute == routeName) {
        ref.read(activeItemProvider.notifier).state = routeName;
      }
    }
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    for (var routeName in TRoutes.sideMenuItems) {
      if (previousRoute == routeName) {
        ref.read(activeItemProvider.notifier).state = routeName;
      }
    }
  }



}
