import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/providers/categories.dart';
import 'package:flutter_complete_guide/providers/light.dart';
import 'package:flutter_complete_guide/providers/users.dart';
import 'package:flutter_complete_guide/widgets/category_item.dart';
import 'package:flutter_complete_guide/widgets/circular_menu.dart';
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
  void dispose() {
    // TODO: implement dispose
    _isInit = false;
    _isLoading = false;
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    print('INIT_STATE => CATEGORIES-SCREEN');

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        String auth = Provider.of<Auth>(context, listen: false).token;
        String uid = Provider.of<Auth>(context, listen: false).userId;
        final List args = ModalRoute.of(context).settings.arguments ?? [];
        String _email = args.length != 0 ? args[0] : '';
        bool _isSeller = args.length != 0 ? args[1] : false;
        print('EMAIL | Seller | uid => $_email | $_isSeller | $uid');

        /// 1.ADD USERS: IF NOT ADDED ALREADY:-
        Provider.of<Users>(context, listen: false).addUser(_email, _isSeller);
      },
    );
  }

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    if (_isInit == true) {
      print('IS_INIT => CATEGORIES-SCREEN');
      setState(() {
        _isLoading = true;
      });

      /// FETCH ALL CATEGORIES:-

      /// 1.FETCH ALL USERS:-
      try {
        Provider.of<Users>(context).fetchUsers().then((_) =>
            Provider.of<Categories>(context, listen: false).fetchCategories());
      } catch (error) {
        Provider.of<Categories>(context, listen: false).fetchCategories();
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
    print('BUILD => CATEGORIES SCREEN');
    //final categoriesData = Provider.of<Categories>(context, listen: false).categories;
    return Scaffold(
      drawer: MainDrawer(),
      floatingActionButton: CircularMenu(),
      appBar: AppBar(
        title: Text('Product Categories'),
        actions: <Widget>[],
      ),
      body: _isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () => _refreshCategories(context),
              child: Consumer<Categories>(
                builder: (context, categoriesData, _) =>
                    categoriesData.categories.length == 0
                        ? _buildEmptyContent(context)
                        : GridView(
                            padding: EdgeInsets.all(10),
                            children: categoriesData.categories
                                .map(
                                  (category) => CategoryItem(
                                    id: category.id,
                                    title: category.title,
                                    imgUrl: category.imgUrl,
                                  ),
                                )
                                .toList(),
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
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
