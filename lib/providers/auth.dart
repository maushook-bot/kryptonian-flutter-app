/// Docs => https://firebase.google.com/docs/reference/rest/auth

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _uid;
  Timer _authTimer;

  String _googleToken;
  String _googleUid;

  /// Instantiate FireBase Auth:-
  final _firebaseAuth = FirebaseAuth.instance;

  /// Get google-current-user:-
  User get currentGoogleUser => _firebaseAuth.currentUser;
  String get googleToken {
    final String SECRET_KEY = dotenv.env['SECRET_KEY'];
    _googleToken = SECRET_KEY;
    return _googleToken;
  }

  String get googleUid {
    _googleUid =
        _firebaseAuth.currentUser == null ? null : currentGoogleUser.uid;
    return _googleUid;
  }

  bool get isAuth {
    return token != null;
  }

  /// If you have a token and didn't expire => User Authenticated:-
  String get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    } else if (_token != null && googleToken != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _uid;
  }

  Future<void> _authenticate(String email, String password, String urlSegment,
      bool isEmailSignIn) async {
    final String API_KEY = dotenv.env['API_KEY'];
    final String SECRET_KEY = dotenv.env['SECRET_KEY'];

    if (isEmailSignIn) {
      /// Email SignIn
      print('Inside Email Sign In: $isEmailSignIn');
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
    } else {
      /// Google SignIn
      print('Inside Google Sign In: ${!isEmailSignIn}');
      _token = SECRET_KEY;
      _uid = googleUid;
      notifyListeners();
    }
  }

  Future<void> signup(String email, String password, String urlSegment,
      bool isEmailSignIn) async {
    return _authenticate(email, password, urlSegment, isEmailSignIn);
  }

  Future<void> login(String email, String password, String urlSegment,
      bool isEmailSignIn) async {
    return _authenticate(email, password, urlSegment, isEmailSignIn);
  }

  void logout() async {
    /// Reset Google Sign In Params:-
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await _firebaseAuth.signOut();

    /// Reset Email Sign In params:-
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

  /// GOOGLE SIGN IN:-
  Future<User> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredential = await _firebaseAuth
            .signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        return userCredential.user;
      } else {
        throw FirebaseAuthException(
          code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
          message: 'Missing Google ID Token',
        );
      }
    } else {
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }
}
