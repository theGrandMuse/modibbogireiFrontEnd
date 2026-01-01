import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';


final internetConnectionProvider =
    StreamProvider<InternetStatus>((ref) {
  return InternetConnection().onStatusChange;
});
final connectivityStatusProvider = Provider<void>((ref) {
  final connectivityStatusAsync = ref.watch(internetConnectionProvider);
  connectivityStatusAsync.whenOrNull(
    data: (status) {
      final isConnected = status == InternetStatus.connected;
      if (isConnected) {
        
       //return TLoaders.customToastInternet(message: 'Internet Connection available');
        
      } else {
       //return TLoaders.customToastNoInternet(message: 'No Internet');
      }
    },
    error: (err, stack) {},
    loading: () {},
  );
});

final internetNetworkStatusProvider = StateProvider<bool?>((ref) => null);
