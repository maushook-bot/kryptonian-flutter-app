import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/pallete/deepBlue.dart';
import 'package:flutter_complete_guide/providers/cart.dart' show CartItem;
import 'package:flutter_complete_guide/providers/light.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrdersItem extends StatefulWidget {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrdersItem({
    this.id,
    this.amount,
    this.products,
    this.dateTime,
  });

  @override
  State<OrdersItem> createState() => _OrdersItemState();
}

class _OrdersItemState extends State<OrdersItem> {
  bool _showCardFlag = false;

  void _showCardHandler() {
    setState(() {
      _showCardFlag = !_showCardFlag;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        curve: Curves.decelerate,
        height: _showCardFlag
            ? min(widget.products.length * 20 + 200, 250).toDouble()
            : 110,
        child: Card(
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.add_shopping_cart,
                  size: 40,
                  //color: DeepBlue.kToDark,
                  color: Provider.of<Light>(context).themeDark
                      ? Colors.lightBlueAccent
                      : DeepBlue.kToDark,
                ),
                title: Text('\$${widget.amount.toStringAsFixed(2)}'),
                subtitle: Text('${DateFormat.yMMMd().format(widget.dateTime)} '
                    '${DateFormat.Hm().format(widget.dateTime)}'),
                trailing: IconButton(
                  icon: _showCardFlag
                      ? Icon(
                          Icons.expand_less,
                          color: Provider.of<Light>(context).themeDark
                              ? Colors.lightBlueAccent
                              : DeepBlue.kToDark,
                        )
                      : Icon(
                          Icons.expand_more,
                          color: Provider.of<Light>(context).themeDark
                              ? Colors.lightBlueAccent
                              : DeepBlue.kToDark,
                        ),
                  onPressed: _showCardHandler,
                ),
              ),
              _showCardFlag
                  ? _buildDetailsCard(context)
                  : _buildEmptyContent(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context) {
    return Expanded(
      flex: _showCardFlag ? 1 : 0,
      child: Container(
        height: min(widget.products.length * 10 + 100, 180).toDouble(),
        width: double.infinity,
        child: Card(
          margin: EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: widget.products.length,
            itemBuilder: (context, index) => ListTile(
              leading: Icon(
                Icons.view_list_sharp,
                color: Provider.of<Light>(context).themeDark
                    ? Colors.lightBlueAccent
                    : DeepBlue.kToDark,
              ),
              title: Text(widget.products[index].title),
              trailing: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.shopping_cart,
                    color: Provider.of<Light>(context).themeDark
                        ? Colors.lightBlueAccent
                        : DeepBlue.kToDark,
                  ),
                  Container(
                    width: 25,
                    alignment: Alignment.centerLeft,
                    child: Text('${widget.products[index].quantity}x'),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 65,
                    alignment: Alignment.centerRight,
                    child: Text(
                        '\$${(widget.products[index].price * widget.products[index].quantity).toStringAsFixed(2)}'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyContent(BuildContext context) {
    return Container();
  }
}
