import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/pallete/deepBlue.dart';
import 'package:flutter_complete_guide/screens/products_overview_screen.dart';

class CategoryItem extends StatelessWidget {
  final String id;
  final String title;
  final String imgUrl;

  CategoryItem({
    @required this.id,
    @required this.title,
    @required this.imgUrl,
  });

  /// Navigator PushNamed
  void selectCategory(BuildContext context) {
    Navigator.of(context).pushNamed(
      ProductsOverviewScreen.routeName,
      arguments: [id, true],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildGridContent(context);
  }

  Widget _buildGridContent(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: GridTile(
        child: GestureDetector(
          onTap: () => selectCategory(context),
          child: _buildImageAnimatedWidget(imgUrl),
        ),
        footer: GridTileBar(
          leading: Icon(Icons.apps),
          backgroundColor: Colors.black87,
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildImageAnimatedWidget(String imageUrl) {
    return FadeInImage(
      imageErrorBuilder: (context, _, __) =>
          Image.asset('assets/images/product-placeholder.png'),
      placeholder: AssetImage('assets/images/product-placeholder.png'),
      image: NetworkImage(imageUrl),
      fit: BoxFit.cover,
    );
  }

  Widget _buildInkWellContent(BuildContext context) {
    return InkWell(
      onTap: () => selectCategory(context),
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: EdgeInsets.all(0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.black.withOpacity(0.5),
          ),
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(top: 65),
          width: double.infinity,
          height: 22,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white60,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: 'Lato',
            ),
          ),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              DeepBlue.kToDark.shade900,
              DeepBlue.kToDark.shade100,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          image: DecorationImage(
            image: NetworkImage(imgUrl),
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }
}
