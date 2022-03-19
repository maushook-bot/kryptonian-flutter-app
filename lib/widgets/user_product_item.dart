import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/screens/edit_product_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context, listen: true);
    final cartData = Provider.of<Cart>(context);

    return ListTile(
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
      trailing: Container(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pushNamed(
                  EditProductScreen.routeName,
                  arguments: widget.productId),
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () async {
                cartData.deleteItems(widget.productId);
                try {
                  await productsData.deleteProduct(widget.productId);
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
                      title: Text('Attention Schmuck',
                          textAlign: TextAlign.center),
                      content: Text(
                          'Something Went Wrong. Try Deleting Product later!',
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
              },
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
