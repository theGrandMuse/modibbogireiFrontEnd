import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';
import 'package:local_session_timeout/local_session_timeout.dart';

final sessionStreamProvider = StateProvider<StreamController<SessionState>>(
    (ref) => StreamController<SessionState>());

final sessionConfigProvider =
    StateProvider<SessionConfig>((ref) => SessionConfig(
          invalidateSessionForAppLostFocus: const Duration(seconds: 600),
          invalidateSessionForUserInactivity: const Duration(seconds: 600),
        ));
