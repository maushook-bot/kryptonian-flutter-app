import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart' show CartItem;
import 'package:intl/intl.dart';

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
  bool showCardFlag = false;

  void _showCardHandler() {
    setState(() {
      showCardFlag = !showCardFlag;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.add_shopping_cart, size: 40),
            title: Text('\$${widget.amount.toStringAsFixed(2)}'),
            subtitle: Text('${DateFormat.yMMMd().format(widget.dateTime)} '
                '${DateFormat.Hm().format(widget.dateTime)}'),
            trailing: IconButton(
              icon: showCardFlag
                  ? Icon(Icons.expand_less)
                  : Icon(Icons.expand_more),
              onPressed: _showCardHandler,
            ),
          ),
          showCardFlag
              ? _buildDetailsCard(context)
              : _buildEmptyContent(context),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: widget.products.length,
          itemBuilder: (context, index) => ListTile(
            leading: Icon(Icons.view_list_sharp),
            title: Text(widget.products[index].title),
            trailing: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.shopping_cart),
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
    );
  }

  Widget _buildEmptyContent(BuildContext context) {
    return Container();
  }
}
