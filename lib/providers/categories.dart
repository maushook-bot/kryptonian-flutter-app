/// TODO: Later Refactor this block by automating configuration in FireBase
/// i.e Adding Custom Categories by Product Owners
/// Current Feature Supports fixed 8 Categories

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/category.dart';

class CategoriesItem {
  final String categoryId;
  final String categoryTitle;

  CategoriesItem({this.categoryId, this.categoryTitle});
}

class Categories with ChangeNotifier {
  Map<String, CategoriesItem> _categoryItems = {};
  Map<String, dynamic> _categoriesItems = {};
  List<Category> _categories = [
    Category(
      id: 'c1',
      title: 'Electronics',
      imgUrl:
          'https://www.pngitem.com/pimgs/m/247-2474633_transparent-electronics-items-png-png-download.png',
    ),
    Category(
      id: 'c2',
      title: 'Clothing',
      imgUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR43UnRwuzRAlZiClSlNLirgvkY8eJCqAWHEQ&usqp=CAU',
    ),
    Category(
      id: 'c3',
      title: 'Toys',
      imgUrl:
          'http://marveltoynews.com/wp-content/uploads/2013/07/Avengers-Hot-Toys-Thor-Black-Widow-Captain-America-Hawkeye.jpg',
    ),
    Category(
      id: 'c4',
      title: 'Sports',
      imgUrl:
          'https://thumbs.dreamstime.com/b/assorted-sports-equipment-black-11153245.jpg',
    ),
    Category(
      id: 'c5',
      title: 'Beauty Care',
      imgUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRooKtW-v4U8ArQ6I_j7WiIqHGl-KayjtEiIQ&usqp=CAU',
    ),
    Category(
      id: 'c6',
      title: 'Education',
      imgUrl:
          'https://www.lego.com/cdn/cs/history/assets/blt002c90de12385725/LEGO_Education_EV3.jpg?disable=upscale&width=960&quality=50',
    ),
    Category(
      id: 'c7',
      title: 'Food',
      imgUrl:
          'https://img.freepik.com/free-photo/chicken-wings-barbecue-sweetly-sour-sauce-picnic-summer-menu-tasty-food-top-view-flat-lay_2829-6471.jpg?size=626&ext=jpg&ga=GA1.2.1450000434.1639526400',
    ),
    Category(
      id: 'c8',
      title: 'Others',
      imgUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSnNCvZQVZxOl7iMO80Cc6UwgvrEx_WnUbMqw&usqp=CAU',
    ),
  ];

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

  Map<String, dynamic> get categoriesItems {
    _categories.forEach(
      (category) {
        _categoriesItems.addAll({'${category.id}': '${category.title}'});
      },
    );
    return _categoriesItems;
  }

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

  // TODO: For Future Advanced Product Configuration which allows users to add Categories:-
  void addCategoriesItems(String categoryId, String newCategoryTitle) {
    if (_categoryItems.containsKey(categoryId)) {
      _categoryItems.update(
        categoryId,
        (presentCategory) => CategoriesItem(
          categoryId: presentCategory.categoryId,
          categoryTitle: presentCategory.categoryTitle,
        ),
      );
    } else {
      _categoryItems.putIfAbsent(
        categoryId,
        () => CategoriesItem(
          categoryId: categoryId,
          categoryTitle: newCategoryTitle,
        ),
      );
    }
  }
}
