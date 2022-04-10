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

  Future<void> addUser(String email, bool isSeller) async {
    String newSellerId;
    final url = Uri.https(
        'kryptonian-flutter-app-default-rtdb.europe-west1.firebasedatabase.app',
        '/users.json',
        {'auth': auth});
    try {
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
      print('ADD => User');
      final user = User(
        sellerId: newSellerId,
        userId: uid,
        email: email,
        isSeller: isSeller,
      );
      _usersList.add(user);
      notifyListeners();
    } catch (error) {
      print('USER-ERROR: ${error}');
      throw error;
    }
  }

  Future<void> fetchUsers() async {
    print('FETCH => All Users');
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
      print(_usersList);
      notifyListeners();
    } catch (error) {
      print('FETCH: USERS-ERROR => $error');
      throw error;
    }
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
}
