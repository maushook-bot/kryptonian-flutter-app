import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/widgets/badge.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/product.dart';
import 'package:flutter_complete_guide/screens/product_details_screen.dart';
import 'package:provider/provider.dart';

import 'badge.dart';

class ProductItem extends StatelessWidget {
  final int index;
  ProductItem({this.index});

  void _selectProduct(BuildContext context, Product productData) {
    Navigator.of(context).pushNamed(
      ProductDetailsScreen.routeName,
      arguments: productData.id,
    );
  }

  void _cartSubmitHandler(
      Products products, Product productData, Cart cartData) {
    products.showProductQuantity(productData.id, index);
    cartData.addItems(productData.id, productData.title, productData.price);
  }

  @override
  Widget build(BuildContext context) {
    /// Provider.of<> - way to extract data from Product class
    /// If listen: true => notifyListeners triggers the build method
    /// if listen: false => notifyListeners cannot trigger
    /// Consumer<Product> can be wrapped on the Child that needs rebuild when notified
    /// Child Argument in Consumer doesn't rebuild
    final productData = Provider.of<Product>(context, listen: false);
    final cartData = Provider.of<Cart>(context, listen: false);
    //print('Index => $index');
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: GridTile(
        child: GestureDetector(
          onTap: () => _selectProduct(context, productData),
          child: Image.network(
            productData.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              icon: productData.isFavorite
                  ? Icon(Icons.favorite)
                  : Icon(Icons.favorite_border),
              onPressed: () => productData.toggleFavoriteStatus(),
              color: Theme.of(context).accentColor,
            ),
          ),
          backgroundColor: Colors.black87,
          title: Text(
            productData.title,
            textAlign: TextAlign.center,
          ),
          trailing: Consumer<Products>(
            builder: (_, products, __) => Badge(
              color: Colors.black54,
              textColor: Colors.white,
              value: products.item[index].qty.toString(),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () =>
                    _cartSubmitHandler(products, productData, cartData),
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
