import 'package:flutter/material.dart';

class Category with ChangeNotifier {
  final String id;
  final String title;
  final String imgUrl;

  Category({
    this.id,
    this.title,
    this.imgUrl,
  });
}
