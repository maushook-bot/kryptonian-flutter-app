import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/screens/edit_product_screen.dart';
import 'package:flutter_complete_guide/widgets/main_drawer.dart';
import 'package:flutter_complete_guide/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProduct();
  }
  
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context, listen: true);
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
              await productsData.fetchProduct();
            },
            icon: Icon(Icons.more),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
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
      drawer: MainDrawer(),
    );
  }
}
