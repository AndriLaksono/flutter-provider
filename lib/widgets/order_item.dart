import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {

  final ord.OrderItem orderItem;

  OrderItem(this.orderItem);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.orderItem.amount.toStringAsFixed(2)}'),
            subtitle: Text(DateFormat('dd-MM-yyyy hh:mm').format(widget.orderItem.dateTime)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more), 
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              }
            ),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.orderItem.products.length * 20.0 + 50, 100),
              child: ListView(
                children: widget.orderItem.products
                  .map((val) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        val.title, 
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                      ),
                      Text(
                        '${val.quantity}x \$${val.price}',
                        style: TextStyle(fontSize: 18, color: Colors.grey)
                      ),

                    ],
                  )).toList(),
              ),
            )
        ],
      ),
    );
  }
}