import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/product.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/product-details';

  @override
  Widget build(BuildContext context) {
    final List productId_index = ModalRoute.of(context).settings.arguments;
    final String productId = productId_index[0];
    final int index = productId_index[1];
    print("@ProductDetailsScreen => (productId, index): ${productId},${index}");

    /// Provider Data:-
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    final products = Provider.of<Products>(context, listen: false);
    final cartData = Provider.of<Cart>(context, listen: false);

    void _productIncreaseQty(
        Products products, Product productData, Cart cartData) {
      products.addProductQuantity(productData.id, index);
      cartData.addItems(productData.id, productData.title, productData.price);
      print('CALL => CartUpdateHandler, Increase Qty');
    }

    void _productReduceQty(
        Products products, Product productData, Cart cartData) {
      products.decreaseProductQuantity(productData.id, index);
      cartData.reduceItems(productData.id);
      print('CALL => CartUpdateHandler, Decrease Qty');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: FittedBox(
                fit: BoxFit.cover,
                child: ClipRRect(
                  child: _buildImageContent(loadedProduct),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              '\$${loadedProduct.price}',
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                loadedProduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  onPressed: () =>
                      _productReduceQty(products, loadedProduct, cartData),
                  child: Text(
                    '-',
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0.5),
                    color: Colors.black38,
                  ),
                  constraints: BoxConstraints(
                    minWidth: 50,
                    minHeight: 40,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Consumer<Products>(
                      builder: (_, products, __) => Text(
                        products.item[index].qty.toString(),
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      _productIncreaseQty(products, loadedProduct, cartData),
                  child: Text(
                    '+',
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  ),
                )
              ],
            )
          ],
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
}
