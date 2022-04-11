/// Docs => https://firebase.google.com/docs/reference/rest/auth

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _uid;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  /// If you have a token and didn't expire => User Authenticated:-
  String get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _uid;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final String API_KEY = dotenv.env['API_KEY'];
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:${urlSegment}?key=$API_KEY');

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      var responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(message: responseData['error']['message']);
      }

      /// Save Token and Expiry date:-
      _token = responseData['idToken'];
      _uid = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(seconds: int.parse(responseData['expiresIn'])),
        //_expiryDate = DateTime.now().add(
        //  Duration(seconds: 6),
      );

      // Auto-Logout will be triggered after token expiry:-
      _autoLogout();
      notifyListeners();

      /// Shared Pref to Store/Get data from Device:-
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _uid,
          'expiryDate': _expiryDate.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password, String urlSegment) async {
    return _authenticate(email, password, urlSegment);
  }

  Future<void> login(String email, String password, String urlSegment) async {
    return _authenticate(email, password, urlSegment);
  }

  void logout() async {
    _token = null;
    _uid = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    //prefs.remove('userData');
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final _timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(
      Duration(seconds: _timeToExpiry),
      logout,
    );
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('userData')) {
      return false;
    }

    final Map<String, Object> extractedData =
        json.decode(prefs.getString('userData'));
    final expiryDate = DateTime.parse(extractedData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    // Initialize the Auth params:-
    _token = extractedData['token'];
    _uid = extractedData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }
}
