import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/helpers/theme_config.dart';
import 'package:flutter_complete_guide/providers/categories.dart';
import 'package:flutter_complete_guide/providers/light.dart';
import 'package:flutter_complete_guide/widgets/category_item.dart';
import 'package:flutter_complete_guide/widgets/main_drawer.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatelessWidget {
  static const routeName = '/categories';

  Future<void> _refreshCategories(BuildContext context) async {
    await Provider.of<Categories>(context).fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesData =
        Provider.of<Categories>(context, listen: false).categories;
    final categoriesItem = Provider.of<Categories>(context).categoriesItems;
    final lightData = Provider.of<Light>(context);
    final isDark = lightData.themeDark;
    //print('Categories-Item => ${categoriesItem}');

    return ThemeSwitchingArea(
      child: Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
          title: Text('Product Categories'),
          actions: <Widget>[
            ThemeSwitcher(
              clipper: ThemeSwitcherCircleClipper(),
              builder: (context) => IconButton(
                icon: Icon(isDark ? Icons.wb_sunny : Icons.nights_stay_sharp),
                color: isDark ? Colors.yellow : Colors.grey,
                onPressed: () {
                  lightData.toggleLights();
                  ThemeSwitcher.of(context).changeTheme(
                    theme: isDark ? dayTheme : nightTheme,
                  );
                },
              ),
            ),
          ],
        ),
        body: FutureBuilder(
          future: _refreshCategories(context),
          builder: (context, snapshot) => RefreshIndicator(
            onRefresh: () => _refreshCategories(context),
            child: categoriesData.length == 0
                ? _buildEmptyContent(context)
                : GridView(
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
                      childAspectRatio: 3 / 2,

                      /// height / width ratio bit taller than wide
                      crossAxisSpacing: 5,

                      /// Spacing b/w the columns
                      mainAxisSpacing: 5,

                      /// Spacing b/w Rows
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Nothing here 🎧',
            style: TextStyle(
                fontSize: 32,
                color: Provider.of<Light>(context).themeDark
                    ? Colors.white60
                    : Colors.black54),
          ),
          SizedBox(height: 3),
          Text(
            'Add Product Category to get started!',
            style: TextStyle(
                fontSize: 16,
                color: Provider.of<Light>(context).themeDark
                    ? Colors.white60
                    : Colors.black54),
          )
        ],
      ),
    );
  }
}
