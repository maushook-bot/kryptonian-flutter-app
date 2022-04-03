import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/categories.dart';
import 'package:flutter_complete_guide/widgets/category_item.dart';
import 'package:flutter_complete_guide/widgets/main_drawer.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatelessWidget {
  static const routeName = '/categories';

  @override
  Widget build(BuildContext context) {
    final categoriesData = Provider.of<Categories>(context, listen: false).categories;
    final categoriesItem = Provider.of<Categories>(context).categoriesItems;
    //print('Categories-Item => ${categoriesItem}');

    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('Product Categories'),
      ),
      body: GridView(
        padding: EdgeInsets.all(10),
        children: categoriesData
            .map(
              (category) => CategoryItem(
            id: category.id,
            title: category.title,
            imgUrl: category.imgUrl,
          ),
        )
            .toList(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2, /// height / width ratio bit taller than wide
          crossAxisSpacing: 5, /// Spacing b/w the columns
          mainAxisSpacing: 5, /// Spacing b/w Rows
        ),
      ),
    );
  }
}
