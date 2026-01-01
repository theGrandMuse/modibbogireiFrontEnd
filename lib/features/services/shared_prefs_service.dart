import 'dart:convert';
import 'dart:math' hide log;

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {

  static const _userIdKey = 'userId';
  static const _firsNameKey = 'firstName';
  static const _lastNameKey = 'lastName';
  static const _roleIdKey = 'roleId';
  static const _shopIdIdKey = 'shopId';
  static const _securityKey = 'securityKey';
  static const _tokenKey = 'token';
  static const _refreshTokenKey = 'refreshToken';
  static const _tokenExpireKey = 'tokenExpireAt';
  static const _refreshTokenExpireKey = 'refreshTokenExpireAt';
  static const _roleNameKey = 'roleName';

  static String get token {
    final rnd = Random.secure();
    final bytes = List<int>.generate(16, (_) => rnd.nextInt(256));
    return base64Url.encode(bytes);
  }

  static String get refreshToken {
    final rnd = Random.secure();
    final bytes = List<int>.generate(16, (_) => rnd.nextInt(256));
    return base64Url.encode(bytes);
  }

  static Future setUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  static Future setRoleName(String roleName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_roleNameKey, roleName);
  }

static Future<String?> getRoleName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleNameKey);
  }
  

  static Future setFirstName(String firstName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_firsNameKey, firstName);
  }

  static Future<String?> getFistName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_firsNameKey);
  }

  static Future setLastName(String lastName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastNameKey, lastName);
  }

  static Future<String?> getLastName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastNameKey);
  }

  static Future setRoleId(String roleId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_roleIdKey, roleId);
  }

  static Future<String?> getRoleId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleIdKey);
  }

  static Future setShopId(String shopId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_shopIdIdKey, shopId);
  }

  static Future<String?> getShopId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_shopIdIdKey);
  }

  static Future setSecurityKey(String securityKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_securityKey, securityKey);
  }

  static Future<String?> getSecurityKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_securityKey);
  }

  static Future setToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future setRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  static Future setTokenExpire() async {
    final DateTime now = DateTime.now();
    final DateTime tokenExpire = now.add(Duration(seconds: 3600));
    final tokenExpireString = tokenExpire.toIso8601String();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenExpireKey, tokenExpireString);
  }

  static Future updateTokenExpire(int tokenLifeSpan) async {
    final DateTime now = DateTime.now();
    final DateTime tokenExpire = now.add(Duration(seconds: tokenLifeSpan));
    final tokenExpireString = tokenExpire.toIso8601String();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_tokenExpireKey, tokenExpireString);
  }

  static Future<DateTime?> getTokenExpire() async {
    final prefs = await SharedPreferences.getInstance();
    final tokenExpireString = prefs.getString(_tokenExpireKey);
    return tokenExpireString == null ? null : DateTime.parse(tokenExpireString);
  }

  static Future setRefreshTokenExpire() async {
    final DateTime now = DateTime.now();
    final DateTime refreshTokenExpire = now.add(Duration(seconds: 345600));
    final refreshTokenExpireString = refreshTokenExpire.toIso8601String();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _refreshTokenExpireKey, refreshTokenExpireString);
  }

  static Future<DateTime?> getRefreshTokenExpire() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshTokenExpireString = prefs.getString(_refreshTokenExpireKey);
    return refreshTokenExpireString == null
        ? null
        : DateTime.parse(refreshTokenExpireString);
  }

  static Future<void> deleteAllSecureData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<bool> tokenExists(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String? token=  prefs.getString(key);
    return token != null;
  }
}
