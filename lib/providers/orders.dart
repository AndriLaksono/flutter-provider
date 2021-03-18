import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../providers/cart.dart';

var baseUrl = 'flutter-purple-default-rtdb.firebaseio.com';

class OrderItem {
  final String id;
  final double amount;
  final DateTime dateTime;
  final List<CartItem> products;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.dateTime,
    @required this.products
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    var uri = Uri.https(baseUrl, '/orders.json');
    final res = await http.get(uri);
    final List<OrderItem> loadedOrders = [];
    final resData = json.decode(res.body) as Map<String, dynamic>;
    if (resData == null) {
      return;
    }
    resData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
        id: orderId,
        amount: orderData['amount'],
        dateTime: DateTime.parse(orderData['dateTime']),
        products: (orderData['products'] as List<dynamic>).map((el) {
          return CartItem(id: el['id'], title: el['title'], price: el['price'], quantity: el['quantity']);
        }).toList()
      ));
    });

    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    var uri = Uri.https(baseUrl, '/orders.json');
    final timestamp = DateTime.now();
    final res = await http.post(uri, body: json.encode({
      'amount': total,
      'dateTime': timestamp.toIso8601String(),
      'products': cartProducts.map((cp) {
        return {
          'id': cp.id,
          'title': cp.title,
          'quantity': cp.quantity,
          'price': cp.price,
        };
      }).toList()
    }));
    _orders.insert(0, OrderItem(
      id: json.decode(res.body)['name'],
      amount: total,
      dateTime: timestamp,
      products: cartProducts
    ));
    notifyListeners();
  }
}