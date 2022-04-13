import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/screens/edit_product_screen.dart';
import 'package:flutter_complete_guide/widgets/main_drawer.dart';
import 'package:flutter_complete_guide/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    String auth = Provider.of<Auth>(context, listen: false).token;
    String uid = Provider.of<Auth>(context, listen: false).userId;
    await Provider.of<Products>(context, listen: false)
        .fetchProduct(true);
    /// FilterByUser => True.
  }

  @override
  Widget build(BuildContext context) {
    print('BUILD => MANAGE USER PRODUCTS');
    final productsData = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Products"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: () async {
              String auth = Provider.of<Auth>(context, listen: false).token;
              String uid = Provider.of<Auth>(context, listen: false).userId;
              await productsData.fetchProduct(true);
            },
            icon: Icon(Icons.refresh_sharp),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (context, productsData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: productsData.item.length,
                          itemBuilder: (_, index) {
                            return Column(
                              children: [
                                UserProductItem(
                                  index: index,
                                  productId: productsData.item[index].id,
                                  title: productsData.item[index].title,
                                  imageUrl: productsData.item[index].imageUrl,
                                ),
                                Divider(),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
      ),
      //drawer: MainDrawer(),
    );
  }
}
