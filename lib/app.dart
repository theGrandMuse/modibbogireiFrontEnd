import 'dart:async';

import 'package:modibbogirei/features/providers/internet_provider.dart';
import 'package:modibbogirei/features/providers/login_provider.dart';
import 'package:modibbogirei/features/providers/session_provider.dart';
import 'package:modibbogirei/features/services/navigator_service.dart';
import 'package:modibbogirei/utils/device/device_utility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_session_timeout/local_session_timeout.dart';

import 'routes/app_routes.dart';
import 'routes/route_observer.dart';
import 'routes/routes.dart';
import 'utils/constants/text_strings.dart';
import 'utils/device/web_material_scroll.dart';
import 'utils/theme/theme.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});
  @override
  ConsumerState<App> createState() {
    return _AppState();
  }
}

class _AppState extends ConsumerState<App> {
  late final StreamController<SessionState> _sessionStateStream;
  late final SessionConfig _sessionConfig;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _initializeSession();
    _initializeRouter();
    _initializeAuth();
  }

  void _initializeSession() {
    _sessionStateStream = StreamController<SessionState>.broadcast();
    _sessionConfig = SessionConfig(
      invalidateSessionForAppLostFocus: const Duration(seconds: 5),
      invalidateSessionForUserInactivity: const Duration(seconds: 10),
    );

    try {
      _sessionConfig.stream.listen((SessionTimeoutState timeoutEvent) {
        if (!mounted) return;
        _sessionStateStream.add(SessionState.stopListening);

        if (timeoutEvent == SessionTimeoutState.userInactivityTimeout ||
            timeoutEvent == SessionTimeoutState.appFocusTimeout) {
          _router.go(TRoutes.login);
        }
      });
    } catch (_) {}
  }

  void _initializeRouter() {
    _router = GoRouter(
      navigatorKey: NavigationService.navigatorKey,
      initialLocation: TRoutes.dashboard,
      routes: TAppRoute.goRoutes,
      observers: [ref.read(routeObserverProvider)],
    );
  }

  void _initializeAuth() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(loginProvider.notifier).autoAuthenticate();
    });
  }

  @override
  void dispose() {
    _sessionStateStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    !TDeviceUtils.isMacOS ?
    ref.watch(connectivityStatusProvider) : null;
    ref.watch(sessionStreamProvider);

    return SessionTimeoutManager(
      userActivityDebounceDuration: const Duration(seconds: 1),
      sessionConfig: _sessionConfig,
      sessionStateStream: _sessionStateStream.stream,
      child: MaterialApp.router(
        routerConfig: _router,
        title: TTexts.appName,
        themeMode: ThemeMode.light,
        theme: TAppTheme.lightTheme,
        darkTheme: TAppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        scrollBehavior: MyCustomScrollBehavior(),
      ),
    );
  }
}
