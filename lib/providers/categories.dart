/// TODO: Later Refactor this block by automating configuration in FireBase
/// i.e Adding Custom Categories by Product Owners
/// Current Feature Supports fixed 8 Categories

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/category.dart';
import 'package:http/http.dart' as http;

class CategoriesItem {
  final String categoryId;
  final String categoryTitle;

  CategoriesItem({this.categoryId, this.categoryTitle});
}

class Categories with ChangeNotifier {
  Map<String, dynamic> _categoriesItems = {};
  List<Category> _categories = [];

  final String auth;
  Categories(this.auth, this._categories);

  List<Category> get categories {
    return _categories;
  }

  /// Fetch CategoryId for Matching Category Title:-
  String fetchCategoryId(String title) {
    String catId = '';
    categoriesItems.forEach(
      (key, value) {
        if (value == title) {
          catId = key;
        }
      },
    );
    return catId;
  }

  /// Fetch CategoryTitle for Matching Category Id:-
  String fetchCategoryTitle(String catId) {
    String catTitle = '';
    categoriesItems.forEach(
      (key, value) {
        if (key == catId) {
          catTitle = value;
        }
      },
    );
    return catTitle;
  }

  /// Get a map of Category Items:-
  Map<String, dynamic> get categoriesItems {
    _categories.forEach(
      (category) {
        _categoriesItems.addAll({'${category.id}': '${category.title}'});
      },
    );
    return _categoriesItems;
  }

  /// categoryDropDownItems => Product Categories DropDown:-
  List<Map<String, dynamic>> get categoryDropDownItems {
    List<Map<String, dynamic>> data = [];
    categoriesItems.forEach(
      (catId, catTitle) {
        data.add(
          {
            'display': catTitle,
            'value': catId,
          },
        );
      },
    );
    return data;
  }

  /// TODO: For Future Advanced Product Configuration which allows users to add Categories:-
  /// Firebase CRED => Categories:-

  Future<void> addCategory(Category newCategory) async {
    String newCategoryId;
    final url = Uri.https(
        'kryptonian-flutter-app-default-rtdb.europe-west1.firebasedatabase.app',
        '/categories.json',
        {'auth': auth});

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': newCategory.title,
            'imageUrl': newCategory.imgUrl,
          },
        ),
      );

      newCategoryId = json.decode(response.body)['name'];

      /// ADD NEW Category:-
      print('ADD => Category');
      final categoryData = Category(
        id: newCategoryId,
        title: newCategory.title,
        imgUrl: newCategory.imgUrl,
      );
      _categories.add(categoryData);
      notifyListeners();
    } catch (error) {
      print('Add Categories-Error => ${error}');
      throw error;
    }
  }

  void updateCategory(String categoryId, Category newCategory) {}

  void deleteCategory(String categoryId) {}

  Future<void> fetchCategories() async {
    final url = Uri.https(
        'kryptonian-flutter-app-default-rtdb.europe-west1.firebasedatabase.app',
        '/categories.json',
        {'auth': auth});

    try {
      final response = await http.get(url);
      final Map<String, dynamic> result = json.decode(response.body);
      final List<Category> LoadedCategory = [];
      result['error'] == 'Permission denied'
          ? throw 'Authentication Failed Permission Denied!'
          : result.forEach(
            (key, category) {
              LoadedCategory.add(
            Category(
              id: key,
              title: category['title'],
              imgUrl: category['imageUrl'],
            ),
          );
        },
      );
      _categories = LoadedCategory;
      //print(_categories);
      notifyListeners();
    } catch (error) {
      print('Fetch Categories-ERROR => $error');
      throw error;
    }

  }
}
