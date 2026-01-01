import 'dart:async';
import 'dart:convert';

import 'package:modibbogirei/features/services/shared_prefs_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:crypto/crypto.dart';

import 'package:modibbogirei/features/models/user_model.dart';
import 'package:modibbogirei/features/providers/session_provider.dart';
import 'package:modibbogirei/features/services/database_service.dart';
import 'package:modibbogirei/features/services/http_service.dart';

import '../../../utils/popups/loaders.dart';

final dbService = DatabaseService();
//final securedStorage = SecureStorage();
//final prefs = SharedPrefsService();

/// Controller for handling login functionality
class LoginNotifier extends StateNotifier<bool> {
  LoginNotifier(this.ref) : super(false);

  Ref ref;
  Timer? _authTimer;

  Future<bool> logout() async {
    _authTimer?.cancel();
    state = false;
    SharedPrefsService.deleteAllSecureData();
    return state;
  }

  void checkTokenExpiration() async {
    final expiryTimeRefreshString =
        await SharedPrefsService.getRefreshTokenExpire();

    //final expiryTimeToken = await SecureStorage.getTokenExpire();
    if (DateTime.now().isAfter(expiryTimeRefreshString!)) {
      // log('Time up');
      logout();
    } else {
      SharedPrefsService.updateTokenExpire(3600);
      setAuthTimeout(3600);
    }
  }

  void setAuthTimeout(int time) async {
    _authTimer = Timer(Duration(seconds: time), checkTokenExpiration);
  }

  Future<bool> signIn(String username, String password) async {
    final sessionStateStream = ref.read(sessionStreamProvider);

    sessionStateStream.add(SessionState.startListening);

    final utf8Encoder = utf8.encoder;
    var shaPassword = sha1.convert(utf8Encoder.convert(password)).toString();

    bool isConnected = await InternetConnection().hasInternetAccess;
    if (isConnected) {
      String endpoint = 'login.php?username=$username&password=$password';
      final response = await HttpService.get(endpoint);
      //log(response.body);
      dynamic jsonData = jsonDecode(response.body);
      if (jsonData.length > 0) {
        Map<String, dynamic> data = {
          "firstName": jsonData[0]['firstName'],
          "lastName": jsonData[0]['lastName'],
          "roleId": jsonData[0]['roleId'],
          "userId": jsonData[0]['userId'],
          "shopId": jsonData[0]['shopId'],
          "roleName": jsonData[0]['roleName'],
        };
        UserModel user = UserModel.fromJson(data);
        ref.read(userModelProvider.notifier).state = user;

        SharedPrefsService.setUserId(user.userId);
        SharedPrefsService.setFirstName(user.firstName);
        SharedPrefsService.setLastName(user.lastName);
        SharedPrefsService.setRoleId(user.roleId.toString());
        SharedPrefsService.setShopId(user.shopId);
        SharedPrefsService.setRefreshToken();
        SharedPrefsService.setRefreshTokenExpire();
        SharedPrefsService.setToken();
        SharedPrefsService.setTokenExpire();
        SharedPrefsService.setSecurityKey(jsonData[0]['securityKey']);
        SharedPrefsService.setRoleName(user.roleName);

        // TFullScreenLoader.stopLoading();
        //final dbService = DatabaseService();

        List<Map<String, dynamic>> userExist =
            await dbService.getWhere('user_details', 'userId', user.userId);
        if (userExist.isEmpty) {
          await dbService.insert('user_details', {
            'userId': user.userId,
            'accessCode': username,
            'passCode': shaPassword,
            'firstName': user.firstName,
            'lastName': user.lastName,
            'otherName': user.otherName,
            'roleId': user.roleId,
            'shopId': user.shopId
          });
        }
      } else {
        // log('Not Connected to Internet');
        TLoaders.errorSnackBar(
            title: 'Error', message: 'Username or Password incorrect');
      }
    } else {
      TLoaders.errorSnackBar(title: 'Not Connected');
      /* 
      final String sql =
          "SELECT * FROM user_details WHERE accessCode = ? AND passCode = ?";

      List<Map<String, dynamic>> userRow =
          await dbService.rawQuery(sql, [username, shaPassword]);

      if (userRow.isNotEmpty) {
        Map<String, dynamic> data = {
          "firstName": userRow[0]['firstName'],
          "lastName": userRow[0]['lastName'],
          "roleId": userRow[0]['roleId'].toString(),
          "userId": userRow[0]['userId'],
          "shopId": userRow[0]['shopId'] ?? '',
        };
        //log(data.toString());
        UserModel user = UserModel.fromJson(data);
        ref.read(userModelProvider.notifier).state = user;
        state = true;

        setAuthTimeout(3600);

        SharedPrefsService.setUserId(user.userId);
        SharedPrefsService.setFirstName(user.firstName);
        SharedPrefsService.setLastName(user.lastName);
        SharedPrefsService.setRoleId(user.roleId.toString());
        SharedPrefsService.setShopId(user.shopId);
        SharedPrefsService.setRefreshToken();
        SharedPrefsService.setRefreshTokenExpire();
        SharedPrefsService.setToken();
        SharedPrefsService.setTokenExpire();
        //TFullScreenLoader.stopLoading();

        // Get.offAndToNamed(TRoutes.populationPage);
      } else {
        // TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
            title: 'Error', message: 'Something went wrong!');
      } */
    }
    return state;
  }

  void autoAuthenticate() async {
    //final token = SharedPrefsService.getToken();
    bool exists = await SharedPrefsService.tokenExists('token');
    final expiryTimeString = await SharedPrefsService.getTokenExpire();
    if (exists) {
      final DateTime now = DateTime.now();
      if (expiryTimeString!.isBefore(now)) {
        state = false;
        return;
      }
      String? firstName = await SharedPrefsService.getFistName();
      String? lastName = await SharedPrefsService.getLastName();
      String? roleId = await SharedPrefsService.getRoleId();
      String? userId = await SharedPrefsService.getUserId();
      String? shopId = await SharedPrefsService.getShopId();
      String? roleName = await SharedPrefsService.getRoleName();

      Map<String, dynamic> data = {
        "firstName": firstName,
        "lastName": lastName,
        "roleId": roleId,
        "userId": userId,
        "shopId": shopId,
        "roleName": roleName
      };

      UserModel.fromJson(data);
      final int tokenLifespan = expiryTimeString.difference(now).inSeconds;
      SharedPrefsService.updateTokenExpire(tokenLifespan);
      setAuthTimeout(tokenLifespan);
      state = true;
    }
  }

  @override
  void dispose() {
    _authTimer?.cancel();
    super.dispose();
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, bool?>((ref) {
  return LoginNotifier(ref);
});

final userModelProvider = StateProvider<UserModel?>((ref) => null);
