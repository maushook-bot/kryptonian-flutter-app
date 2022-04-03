import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/widgets/product_item.dart';
import 'package:provider/provider.dart';

class productsGrid extends StatelessWidget {
  final bool showFavoriteOnly;
  final String categoryId;
  final bool categoryFlag;
  productsGrid({this.showFavoriteOnly, this.categoryId, this.categoryFlag});

  @override
  Widget build(BuildContext context) {
    //final productData = Provider.of<Products>(context);
    //final products = productData.item;
    //final filteredProducts = showFavoriteOnly ? productData.favoriteItems : products;

    /// Fetch Products by Categories:-
    final filteredProducts = Provider.of<Products>(context)
        .fetchProductByCategories(categoryId, categoryFlag);

    return GridView.builder(
      itemCount: filteredProducts.length,
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: filteredProducts[index],
        child: ProductItem(index: index),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 3 / 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        crossAxisCount: 2,
      ),
    );
  }
}
