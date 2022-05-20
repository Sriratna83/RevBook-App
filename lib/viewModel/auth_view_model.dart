import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:revbook_app/models/api/auth_api.dart' as AuthApi;

class AuthViewModel with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token!;
    }
    return null;
  }

  String? get userId => _userId;

  Future<void> _auth(Function apiMethod, String email, String password) async {
    try {
      final String data = json.encode({
        "email": email,
        "password": password,
        "returnSecureToken": true,
      });

      final response = await apiMethod(data);
      final responseData = json.decode(response.toString());
      _token = responseData["idToken"];
      _userId = responseData["localId"];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData["expiresIn"])));
      _autoLogout();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        "token": _token,
        "userId": _userId,
        "expiryDate": _expiryDate!.toIso8601String(),
      });
      notifyListeners();
      prefs.setString("userData", userData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    await _auth(AuthApi.signUp, email, password);
    // notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    await _auth(AuthApi.signIn, email, password);
    // notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) return false;

    final extractedUserData =
        json.decode(prefs.getString("userData")!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData["expiryDate"]);

    if (expiryDate.isBefore(DateTime.now())) return false;

    _token = extractedUserData["token"];
    _userId = extractedUserData["userId"];
    _expiryDate = expiryDate;
    notifyListeners();

    return true;
  }

  Future<void> logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;

    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    _authTimer = null;

    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("userData");
  }

  _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
