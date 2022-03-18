import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/product.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _priceFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
    qty: 0,
  );

  var _isInit = true;
  var isLoading = false;

  var _initValues = {
    'id': null,
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    // TODO: implement initState
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      final String productId = ModalRoute.of(context).settings.arguments;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'id': _editedProduct.id,
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
          'imageUrl': '',
        };

        /// When controller used in TextFormField initial value can't be set
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _priceFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageUrl() {}

  Future<void> _saveForm(Products productsData) async {
    final isValid = _form.currentState.validate();
    print('Valid: $isValid');
    if (!isValid) {
      return;
    }
    _form.currentState.save();

    // Set Loading Indicator:-
    setState(() {
      isLoading = true;
    });

    /// Save Contents to Products Provider:-
    if (_editedProduct.id == null) {
      try {
        await productsData.addProduct(_editedProduct);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (context) => AlertDialog(
            elevation: 10.4,
            title: Text('Attention Schmuck', textAlign: TextAlign.center),
            content: Text('Something Went Wrong!', textAlign: TextAlign.center),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Close'),
              ),
            ],
          ),
        );
      } finally {
        // Reset Loading Indicator:-
        setState(() {
          isLoading = false;
        });

        /// Pop this screen:-
        Navigator.of(context).pop();

        /// Stats:-
        print('id: ${_editedProduct.id}');
        print('title: ${_editedProduct.title}');
        print('description: ${_editedProduct.description}');
        print('price: ${_editedProduct.price}');
        print('imageUrl: ${_editedProduct.imageUrl}');
      }
    } else {
      /// EDIT Existing Products:-
      //Provider.of<Cart>(context, listen: false).updateItems(_editedProduct.id, _editedProduct);
      Provider.of<Cart>(context, listen: false).deleteItems(_editedProduct.id);
      productsData.updateProduct(_editedProduct.id, _editedProduct);

      print('id: ${_editedProduct.id}');
      print('title: ${_editedProduct.title}');
      print('description: ${_editedProduct.description}');
      print('price: ${_editedProduct.price}');
      print('imageUrl: ${_editedProduct.imageUrl}');
      print('qty: ${_editedProduct.qty}');

      // Reset Loading Indicator:-
      setState(() {
        isLoading = false;
      });

      /// Pop this screen:-
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context, listen: true);
    final cartData = Provider.of<Cart>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit My Products"),
        actions: [
          IconButton(
            onPressed: () {
              _saveForm(productsData);
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: isLoading == true
          ? Center(child: CircularProgressIndicator())
          : Container(
              height: 480,
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 10.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _form,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        TextFormField(
                          initialValue: _initValues['title'],
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(labelText: 'Title'),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_priceFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "This Field Value Is Schmuck";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            /// ADD NEW PRODUCT/ EDIT EXISTING PRODUCT
                            _editedProduct = Product(
                              id: _editedProduct.id,
                              title: value,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl,
                              isFavorite: _editedProduct.isFavorite,
                            );
                          },
                        ),
                        TextFormField(
                          initialValue: _initValues['price'],
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(labelText: 'Price'),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          focusNode: _priceFocusNode,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter a Price Schmuck';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Enter a valid number Schmuck';
                            }
                            if (double.parse(value) <= 0) {
                              return 'Enter a number greater than zero';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              price: double.parse(value),
                              imageUrl: _editedProduct.imageUrl,
                              isFavorite: _editedProduct.isFavorite,
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 25, right: 10),
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.black),
                                borderRadius: BorderRadius.circular(1),
                              ),
                              child: _imageUrlController.text.isEmpty
                                  ? Text('Enter a Url')
                                  : FittedBox(
                                      child: Image.network(
                                        _imageUrlController.text,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                            ),
                            Expanded(
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration:
                                    InputDecoration(labelText: 'Image Url'),
                                keyboardType: TextInputType.url,
                                controller: _imageUrlController,
                                textInputAction: TextInputAction.done,
                                onEditingComplete: () {
                                  setState(() {});
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Enter an image URL Schmuck';
                                  }
                                  if (!value.startsWith('http') &&
                                      !value.startsWith('https')) {
                                    return 'Enter a valid URL Schmuck';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  // TODO: ADD PRODUCT
                                  _editedProduct = Product(
                                    id: _editedProduct.id,
                                    title: _editedProduct.title,
                                    description: _editedProduct.description,
                                    price: _editedProduct.price,
                                    imageUrl: value,
                                    isFavorite: _editedProduct.isFavorite,
                                  );
                                },
                                onFieldSubmitted: (_) {
                                  _saveForm(productsData);
                                },
                              ),
                            ),
                          ],
                        ),
                        TextFormField(
                          initialValue: _initValues['description'],
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(labelText: 'Description'),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          onSaved: (value) {
                            _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: value,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl,
                              isFavorite: _editedProduct.isFavorite,
                            );
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter a Description Schmuck';
                            }
                            if (value.length < 10) {
                              return 'Should be at least 10 chars along Schmuck';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
