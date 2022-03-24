import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/screens/edit_product_screen.dart';
import 'package:flutter_complete_guide/screens/products_overview_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatefulWidget {
  final int index;
  final String productId;
  final String title;
  final String imageUrl;

  UserProductItem({
    @required this.index,
    @required this.productId,
    @required this.title,
    @required this.imageUrl,
  });

  @override
  State<UserProductItem> createState() => _UserProductItemState();
}

class _UserProductItemState extends State<UserProductItem> {
  bool _isImgErr = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    setState(() {
      _isImgErr = false;
    });
    super.didChangeDependencies();
  }

  void _productDismissHandler(DismissDirection direction, BuildContext context,
      Products productsData, Cart cartData) async {
    String auth = Provider.of<Auth>(context, listen: false).token;
    if (direction == DismissDirection.endToStart) {
      /// Right -> Left => DELETE
      cartData.deleteItems(widget.productId);
      try {
        await productsData.deleteProduct(widget.productId, auth);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product Deleted!'),
          ),
        );
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (context) => AlertDialog(
            elevation: 10.4,
            title: Text('Attention Schmuck', textAlign: TextAlign.center),
            content: Text('Something Went Wrong. Try Deleting Product later!',
                textAlign: TextAlign.center),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Close'),
              ),
            ],
          ),
        );
      }
    } else if (direction == DismissDirection.startToEnd) {
      /// Left -> Right => EDIT
      Navigator.of(context)
          .pushNamed(EditProductScreen.routeName, arguments: widget.productId);
    }
  }

  void _callEditProductHandler() {
    Navigator.of(context)
        .pushNamed(EditProductScreen.routeName, arguments: widget.productId);
  }

  void _callDeleteProductHandler(Products productsData, Cart cartData) async {
    cartData.deleteItems(widget.productId);
    String auth = Provider.of<Auth>(context, listen: false).token;
    try {
      await productsData.deleteProduct(widget.productId, auth);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product Deleted!'),
        ),
      );
    } catch (error) {
      await showDialog<Null>(
        context: context,
        builder: (context) => AlertDialog(
          elevation: 10.4,
          title: Text('Attention Schmuck', textAlign: TextAlign.center),
          content: Text('Something Went Wrong. Try Deleting Product later!',
              textAlign: TextAlign.center),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context, listen: true);
    final cartData = Provider.of<Cart>(context);

    return Slidable(
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            key: const ValueKey(0),
            flex: 2,
            onPressed: (ctx) => _callEditProductHandler(),
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            key: const ValueKey(1),
            flex: 2,
            onPressed: (ctx) =>
                _callDeleteProductHandler(productsData, cartData),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        child: ListTile(
          title: Text(widget.title),
          leading: _isImgErr == false
              ? CircleAvatar(
                  backgroundImage: NetworkImage(widget.imageUrl),
                  onBackgroundImageError: (error, _) {
                    setState(() {
                      _isImgErr = true;
                    });
                  },
                )
              : CircleAvatar(
                  backgroundImage: AssetImage('assets/images/placeholder.png'),
                ),
          trailing: Icon(Icons.double_arrow_sharp)
        ),
      ),
    );
  }
}
