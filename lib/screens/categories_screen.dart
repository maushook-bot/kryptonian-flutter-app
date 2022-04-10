import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/categories.dart';
import 'package:flutter_complete_guide/providers/light.dart';
import 'package:flutter_complete_guide/providers/users.dart';
import 'package:flutter_complete_guide/widgets/category_item.dart';
import 'package:flutter_complete_guide/widgets/main_drawer.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatefulWidget {
  static const routeName = '/categories';

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    if (_isInit == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        await Provider.of<Users>(context).fetchUsers();
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
      }
    }
    _isInit = false;
    setState(() {
      _isLoading = false;
    });
    super.didChangeDependencies();
  }

  Future<void> _refreshCategories(BuildContext context) async {
    await Provider.of<Categories>(context).fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesData =
        Provider.of<Categories>(context, listen: false).categories;

    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('Product Categories'),
        actions: <Widget>[],
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
