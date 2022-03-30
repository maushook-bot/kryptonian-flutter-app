import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/pallete/deepBlue.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/product.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const routeName = '/product-details';

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  ScrollController _scrollController;
  bool lastStatus = true;

  void _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return (_scrollController.hasClients) &&
        (_scrollController.offset > (295 - kToolbarHeight));
  }

  @override
  void initState() {
    // TODO: implement initState
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
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
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            centerTitle: true,
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                decoration: BoxDecoration(
                    color: isShrink
                        ? Theme.of(context).primaryColor
                        : Colors.black54,
                    borderRadius: BorderRadius.circular(12)),
                width: _deviceSize.width,
                padding: isShrink ? EdgeInsets.all(0) : EdgeInsets.all(5),
                child: Text(loadedProduct.title, textAlign: TextAlign.justify),
              ),
              background: Hero(
                tag: loadedProduct.id,
                child: _buildImageContent(loadedProduct),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  margin: EdgeInsets.all(10),
                  elevation: 20.0,
                  child: Container(
                    color: DeepBlue.kToDark,
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.monetization_on_outlined,
                            size: 30, color: Colors.white),
                        Container(
                          margin:
                              EdgeInsets.only(right: _deviceSize.width * 0.12),
                          child: Text(
                            'Product Price',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white60),
                          ),
                        ),
                        Text(
                          '\$${loadedProduct.price}',
                          style: TextStyle(color: Colors.grey, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  margin: EdgeInsets.all(10),
                  elevation: 20.0,
                  child: Container(
                    color: DeepBlue.kToDark,
                    padding: EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.add_shopping_cart_outlined,
                            size: 30, color: Colors.white),
                        Container(
                          margin:
                              EdgeInsets.only(right: _deviceSize.width * 0.06),
                          child: Text(
                            'Modify Cart',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white60),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              onPressed: () => _productIncreaseQty(
                                  products, loadedProduct, cartData),
                              icon: Icon(
                                Icons.keyboard_arrow_up,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0.5),
                                color: Colors.lightBlueAccent,
                              ),
                              constraints: BoxConstraints(
                                minWidth: 20,
                                minHeight: 20,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Consumer<Products>(
                                  builder: (_, products, __) => Text(
                                    products.item[index].qty.toString(),
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () => _productReduceQty(
                                    products, loadedProduct, cartData),
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Card(
                      margin: EdgeInsets.all(15),
                      child: Container(
                        width: _deviceSize.width * 0.86,
                        margin: EdgeInsets.only(
                            right: 1, left: 14, top: 12, bottom: 12),
                        child: Text(
                          'Description',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    loadedProduct.description,
                    textAlign: TextAlign.justify,
                    softWrap: true,
                  ),
                ),
                SizedBox(height: 800),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Image _buildImageContent(Product productData) {
    return Image.network(
      productData.imageUrl,
      errorBuilder: (context, error, stackTrace) =>
          Image.asset('assets/images/placeholder.png'),
      fit: BoxFit.cover,
    );
  }
}
