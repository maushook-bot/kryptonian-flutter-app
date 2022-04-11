import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class User {
  final String sellerId;
  final String userId;
  final String email;
  final bool isSeller;

  User({this.sellerId, this.userId, this.email, this.isSeller});
}

class Users with ChangeNotifier {
  /// TODO: SELLER-USER Relationship:-
  List<User> _usersList = [];
  final String auth;
  final String uid;

  Users(this.auth, this.uid, this._usersList);

  List<User> get usersList {
    return [..._usersList];
  }

  bool get fetchIsSeller {
    bool isSeller;
    _usersList.forEach(
      (user) {
        if (user.userId == uid) {
          isSeller = user.isSeller;
        }
      },
    );
    return isSeller;
  }

  String get userName {
    String email;
    int startIndex;
    int endIndex;

    _usersList.forEach(
      (user) {
        if (user.userId == uid) {
          email = user.email;
        }
      },
    );

    /// Extract name from email:-
    const start = "";
    const end = "@";
    try {
      startIndex = email.indexOf(start);
      endIndex = email.indexOf(end, startIndex + start.length);
    } catch (error) {
      startIndex = 0;
      endIndex = 0;
    }
    if (email != null) {
      return email.substring(startIndex + start.length, endIndex);
    } else
      return '';
  }

  Future<void> addUser(String email, bool isSeller) async {
    print('ADD => User | $email | isSeller: $isSeller | uid: $uid | auth');
    String newSellerId;
    try {
      final url = Uri.https(
          'kryptonian-flutter-app-default-rtdb.europe-west1.firebasedatabase.app',
          '/users.json',
          {'auth': auth});
      if (email != '') {
        final response = await http.post(
          url,
          body: json.encode(
            {
              'userId': uid,
              'email': email,
              'isSeller': isSeller,
            },
          ),
        );
        newSellerId = json.decode(response.body)['name'];

        /// ADD NEW PRODUCT
        final user = User(
          sellerId: newSellerId,
          userId: uid,
          email: email,
          isSeller: isSeller,
        );
        _usersList.add(user);
        print('ADD => User Added');
        notifyListeners();
      } else {
        print('ADD => User not Added');
      }
    } catch (error) {
      print('ADD USER-ERROR: ${error}');
      throw error;
    }
  }

  Future<void> fetchUsers() async {
    //print('FETCHED => All Users');
    final url = Uri.https(
        'kryptonian-flutter-app-default-rtdb.europe-west1.firebasedatabase.app',
        '/users.json',
        {'auth': auth});

    try {
      final response = await http.get(url);
      final Map<String, dynamic> result = json.decode(response.body);
      final List<User> LoadedUsers = [];
      result['error'] == 'Permission denied'
          ? throw 'Authentication Failed Permission Denied!'
          : result.forEach(
              (key, user) {
                LoadedUsers.add(
                  User(
                    sellerId: key,
                    userId: user['userId'],
                    email: user['email'],
                    isSeller: user['isSeller'],
                  ),
                );
              },
            );
      _usersList = LoadedUsers;
      //print(_usersList);
      notifyListeners();
    } catch (error) {
      print('FETCH: USERS-ERROR => $error');
      throw error;
    }
  }
}
