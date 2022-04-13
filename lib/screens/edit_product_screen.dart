import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/pallete/deepBlue.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/categories.dart';
import 'package:flutter_complete_guide/providers/light.dart';
import 'package:flutter_complete_guide/providers/product.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/screens/new_category_drawer.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

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
  String _selectCategory;

  var _editedProduct = Product(
      id: null,
      title: '',
      description: '',
      price: 0,
      imageUrl: '',
      qty: 0,
      categoryId: '');

  var _isInit = true;
  var isLoading = false;

  var _initValues = {
    'id': null,
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
    'category': '',
  };

  @override
  void initState() {
    // TODO: implement initState
    //_selectCategory = '';
    //_imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      final String productId = ModalRoute.of(context).settings.arguments;
      final catData = Provider.of<Categories>(context, listen: false);
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'id': _editedProduct.id,
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
          'imageUrl': '',
          'category': catData.fetchCategoryTitle(_editedProduct.categoryId),
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

  void _showCategoryDrawer() {
    final deviceSize = MediaQuery.of(context).size;
    showModalBottomSheet(
      elevation: 10,
      //constraints: BoxConstraints(maxHeight: deviceSize.height * 0.3),
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return GestureDetector(
          onTap: () => {},
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: NewCategoryDrawer(),
          ),
        );
      },
    );
  }

  Future<void> _saveForm(Products productsData) async {
    final isValid = _form.currentState.validate();
    String auth = Provider.of<Auth>(context, listen: false).token;
    String uid = Provider.of<Auth>(context, listen: false).userId;
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
      }
    } else {
      /// EDIT Existing Products:-
      //Provider.of<Cart>(context, listen: false).updateItems(_editedProduct.id, _editedProduct);
      Provider.of<Cart>(context, listen: false).deleteItems(_editedProduct.id);
      String auth = Provider.of<Auth>(context, listen: false).token;

      await productsData.updateProduct(_editedProduct.id, _editedProduct);

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
    print('BUILD => EDIT PRODUCTS SCREEN');
    final productsData = Provider.of<Products>(context, listen: true);
    final cartData = Provider.of<Cart>(context, listen: true);
    final catData = Provider.of<Categories>(context, listen: false);
    final deviceSize = MediaQuery.of(context).size;

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
      floatingActionButton: FloatingActionButton(
        elevation: 20,
        backgroundColor: Provider.of<Light>(context).themeDark
            ? Colors.deepOrange
            : DeepBlue.kToDark,
        foregroundColor:
            Provider.of<Light>(context).themeDark ? Colors.black : Colors.white,
        child: Icon(Icons.add),
        onPressed: () => _showCategoryDrawer(),
      ),
      body: isLoading == true
          ? Center(child: CircularProgressIndicator())
          : Container(
              height: deviceSize.height * 0.74,
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
                          decoration: InputDecoration(
                            labelText: 'Title',
                            labelStyle: TextStyle(
                              color: Provider.of<Light>(context).themeDark
                                  ? Colors.white60
                                  : Colors.black.withOpacity(0.55),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Provider.of<Light>(context).themeDark
                                    ? Colors.white60
                                    : Colors.black.withOpacity(0.5),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Provider.of<Light>(context).themeDark
                                    ? Colors.lightBlueAccent
                                    : DeepBlue.kToDark,
                              ),
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Provider.of<Light>(context).themeDark
                                    ? Colors.lightBlueAccent
                                    : DeepBlue.kToDark,
                              ),
                            ),
                          ),
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
                              categoryId: _editedProduct.categoryId,
                            );
                          },
                        ),
                        TextFormField(
                          initialValue: _initValues['price'],
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            labelText: 'Price',
                            labelStyle: TextStyle(
                              color: Provider.of<Light>(context).themeDark
                                  ? Colors.white60
                                  : Colors.black.withOpacity(0.55),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Provider.of<Light>(context).themeDark
                                    ? Colors.white60
                                    : Colors.black.withOpacity(0.5),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Provider.of<Light>(context).themeDark
                                    ? Colors.lightBlueAccent
                                    : DeepBlue.kToDark,
                              ),
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Provider.of<Light>(context).themeDark
                                    ? Colors.lightBlueAccent
                                    : DeepBlue.kToDark,
                              ),
                            ),
                          ),
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
                              categoryId: _editedProduct.categoryId,
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
                                decoration: InputDecoration(
                                  labelText: 'Image Url',
                                  labelStyle: TextStyle(
                                    color: Provider.of<Light>(context).themeDark
                                        ? Colors.white60
                                        : Colors.black.withOpacity(0.55),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          Provider.of<Light>(context).themeDark
                                              ? Colors.white60
                                              : Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          Provider.of<Light>(context).themeDark
                                              ? Colors.lightBlueAccent
                                              : DeepBlue.kToDark,
                                    ),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          Provider.of<Light>(context).themeDark
                                              ? Colors.lightBlueAccent
                                              : DeepBlue.kToDark,
                                    ),
                                  ),
                                ),
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
                                    categoryId: _editedProduct.categoryId,
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
                          decoration: InputDecoration(
                            labelText: 'Description',
                            labelStyle: TextStyle(
                              color: Provider.of<Light>(context).themeDark
                                  ? Colors.white60
                                  : Colors.black.withOpacity(0.55),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Provider.of<Light>(context).themeDark
                                    ? Colors.white60
                                    : Colors.black.withOpacity(0.5),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Provider.of<Light>(context).themeDark
                                    ? Colors.lightBlueAccent
                                    : DeepBlue.kToDark,
                              ),
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Provider.of<Light>(context).themeDark
                                    ? Colors.lightBlueAccent
                                    : DeepBlue.kToDark,
                              ),
                            ),
                          ),
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
                              categoryId: _editedProduct.categoryId,
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
                        SizedBox(height: 10),
                        DropDownFormField(
                          titleText: 'Product Category',
                          hintText: 'Choose a category',
                          value: _selectCategory,
                          onSaved: (newValue) {
                            setState(() {
                              _selectCategory = newValue;
                            });
                            _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl,
                              isFavorite: _editedProduct.isFavorite,
                              categoryId: _selectCategory,
                            );
                          },
                          onChanged: (newValue) {
                            setState(() {
                              _selectCategory = newValue;
                            });
                          },
                          dataSource: catData.categoryDropDownItems,
                          textField: 'display',
                          valueField: 'value',
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          initialValue: _initValues['category'],
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            labelText: 'Selected Product Category',
                            labelStyle: TextStyle(
                              color: Provider.of<Light>(context).themeDark
                                  ? Colors.white60
                                  : Colors.black.withOpacity(0.55),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Provider.of<Light>(context).themeDark
                                    ? Colors.white60
                                    : Colors.black.withOpacity(0.5),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Provider.of<Light>(context).themeDark
                                    ? Colors.lightBlueAccent
                                    : DeepBlue.kToDark,
                              ),
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Provider.of<Light>(context).themeDark
                                    ? Colors.lightBlueAccent
                                    : DeepBlue.kToDark,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.text,
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
