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
  void _selectProduct(BuildContext context, Product productData, index) {
    Navigator.of(context).pushNamed(
      ProductDetailsScreen.routeName,
      arguments: [productData.id, index],
    );
  }

  void _cartUpdateHandler(
      Products products, Product productData, Cart cartData) {
    products.addProductQuantity(productData.id, index);
    cartData.addItems(productData.id, productData.title, productData.price);
    print('CALL => CartUpdateHandler');
  }

  void _gestureUpDownHandler(DragUpdateDetails direction, Product productData,
      Products productsData, Cart cartData) {
    int sensitivity = 0;
    if (direction.delta.direction > sensitivity) {
      /// Down Swipe
      productsData.decreaseProductQuantity(productData.id, index);
      cartData.reduceItems(productData.id);
      print('CALL => CartUpdateHandler, Decrease Qty');
    } else if (direction.delta.direction < sensitivity) {
      /// Up Swipe
      productsData.addProductQuantity(productData.id, index);
      cartData.addItems(productData.id, productData.title, productData.price);
      print('CALL => CartUpdateHandler, Increase Qty');
    }
  }

  void _dismissRightHandler(DismissDirection direction, Product productData,
      Products productsData, Cart cartData) {
    /// Right Swipe
    productsData.addProductQuantity(productData.id, index);
    cartData.addItems(productData.id, productData.title, productData.price);
    print('CALL => CartUpdateHandler, Increase Qty');
  }

  void _dismissLeftHandler(DismissDirection direction, Product productData,
      Products productsData, Cart cartData) {
    /// Left Swipe

    productsData.decreaseProductQuantity(productData.id, index);
    cartData.reduceItems(productData.id);
    print('CALL => CartUpdateHandler, Decrease Qty');
  }

  @override
  Widget build(BuildContext context) {
    /// Provider.of<> - way to extract data from Product class
    /// If listen: true => notifyListeners triggers the build method
    /// if listen: false => notifyListeners cannot trigger
    /// Consumer<Product> can be wrapped on the Child that needs rebuild when notified
    /// Child Argument in Consumer doesn't rebuild
    final productData = Provider.of<Product>(context, listen: false);
    final cartData = Provider.of<Cart>(context, listen: true);
    final productsData = Provider.of<Products>(context, listen: true);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: GridTile(
        child: GestureDetector(
          onTap: () => _selectProduct(context, productData, index),
          child: _buildImageAnimatedWidget(productData),
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
          title: Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.horizontal,
            onDismissed: (direction) {
              print('DismissDirection => ${direction.toString()}');
              if (direction.toString() == "DismissDirection.startToEnd") {
                _dismissRightHandler(
                    direction, productData, productsData, cartData);
              } else if (direction.toString() ==
                  "DismissDirection.endToStart") {
                _dismissLeftHandler(
                    direction, productData, productsData, cartData);
              }
            },
            background: _buildDismissRightContainer(),
            secondaryBackground: _buildDismissLeftContainer(),
            child: Text(
              productData.title,
              textAlign: TextAlign.center,
            ),
          ),
          trailing: Consumer<Products>(
            builder: (_, products, __) => Badge(
              color: Colors.black54,
              textColor: Colors.white,
              value: products.item[index].qty.toString(),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  _cartUpdateHandler(products, productData, cartData);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Item Added to Cart 🛒'),
                      duration: Duration(seconds: 3),
                      backgroundColor: Colors.black,
                      action: SnackBarAction(
                        onPressed: () {
                          products.decreaseProductQuantity(
                              productData.id, index);
                          cartData.clearSingleItem(productData.id);
                        },
                        label: 'Undo',
                      ),
                    ),
                  );
                },
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Image _buildImageContent(Product productData) {
    return Image.network(
      productData.imageUrl,
      errorBuilder: (context, error, stackTrace) =>
          Image.asset('assets/images/placeholder.png'),
    );
  }

  Widget _buildImageAnimatedWidget(Product productData) {
    return Hero(
      tag: productData.id,
      child: FadeInImage(
        imageErrorBuilder: (context, _, __) =>
            Image.asset('assets/images/product-placeholder.png'),
        placeholder: AssetImage('assets/images/product-placeholder.png'),
        image: NetworkImage(productData.imageUrl),
        fit: BoxFit.cover,
      ),
    );
  }

  Container _buildDismissRightContainer() {
    return Container(
      height: 50.0,
      width: 50.0,
      color: Colors.black12,
      child: Icon(
        Icons.add_shopping_cart,
        color: Colors.greenAccent,
        size: 18,
      ),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(right: 0),
      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
    );
  }

  Container _buildDismissLeftContainer() {
    return Container(
      height: 50.0,
      width: 50.0,
      color: Colors.black12,
      child: Icon(
        Icons.delete,
        color: Colors.redAccent,
        size: 18,
      ),
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 0),
      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
    );
  }
}
