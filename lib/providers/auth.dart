/// Docs => https://firebase.google.com/docs/reference/rest/auth

import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _uid;

  /// If you have a token and didn't expire => User Authenticated:-
  String get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  bool get isAuth {
    return token != null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:${urlSegment}?key=AIzaSyDhNshuqJew_1kp3JHwMTCqJWgEPTpb_fQ');

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
      //_expiryDate = DateTime.now().add(Duration(seconds: 30),
      );
      print('Token => $_token');
      print('ExpiryDate => ${_expiryDate}');
      print('UserID => ${_uid}');
      notifyListeners();
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
}
