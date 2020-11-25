import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop_app/Provider/orderProvider.dart';
import 'package:intl/intl.dart';

class OrderedItems extends StatefulWidget {
  OrderedItems(this.order);
  final OrderItem order;

  @override
  _OrderedItemsState createState() => _OrderedItemsState();
}

class _OrderedItemsState extends State<OrderedItems> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
                DateFormat('dd MM YYYY hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          //inlist if statemnet
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.order.products.length * 20.0 + 10, 100),
              child: ListView(
                  children: widget.order.products
                      .map((prod) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                prod.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('${prod.quantity}x \$${prod.price}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  )),
                            ],
                          ))
                      .toList()),
            )
        ],
      ),
    );
  }
}
