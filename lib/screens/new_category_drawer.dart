import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/pallete/deepBlue.dart';
import 'package:flutter_complete_guide/providers/categories.dart';
import 'package:flutter_complete_guide/providers/category.dart';
import 'package:flutter_complete_guide/providers/light.dart';
import 'package:flutter_complete_guide/screens/categories_screen.dart';
import 'package:provider/provider.dart';

class NewCategoryDrawer extends StatefulWidget {
  @override
  State<NewCategoryDrawer> createState() => _NewCategoryDrawerState();
}

class _NewCategoryDrawerState extends State<NewCategoryDrawer> {
  final _titleController = TextEditingController();
  final _imageUrlController = TextEditingController();

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredImageUrl = _imageUrlController.text;

    if (enteredTitle.isEmpty || enteredImageUrl.isEmpty) {
      print("Form Contents Empty!");
      return;
    }
    //TODO: Call add category Firebase
    Provider.of<Categories>(context, listen: false).addCategory(
      Category(
        title: enteredTitle,
        imgUrl: enteredImageUrl,
      ),
    );
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.black,
        content: Text(
          'Product Category Added Successfully 🏁',
          style:
              TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
        ),
      ),
    );

    print('${enteredTitle} |  ${enteredImageUrl}');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 30,
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
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
                  labelText: 'Category Title',
                  labelStyle: TextStyle(
                    color: Provider.of<Light>(context).themeDark
                        ? Colors.white60
                        : Colors.black.withOpacity(0.55),
                  ),
                ),
                controller: _titleController,
                textInputAction: TextInputAction.next,
                /*onChanged: (value) => titleInput = value,*/
              ),
              TextField(
                decoration: InputDecoration(
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
                  labelText: 'Image Url',
                  labelStyle: TextStyle(
                    color: Provider.of<Light>(context).themeDark
                        ? Colors.white60
                        : Colors.black.withOpacity(0.55),
                  ),
                ),
                controller: _imageUrlController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                /*onChanged: (value) => amountInput = value,*/
              ),
              SizedBox(height: 20),
              RaisedButton(
                onPressed: () => _submitData(),
                color: Provider.of<Light>(context).themeDark
                    ? Colors.blueAccent
                    : DeepBlue.kToDark,
                child: Text(
                  'Add Category',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
