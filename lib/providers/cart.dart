import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.quantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  
  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items != null ? _items.length : 0;
  }

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(productId, (value) => CartItem(
        id: value.id,
        title: value.title,
        price: value.price,
        quantity: value.quantity + 1
      ));
    } else {
      _items.putIfAbsent(productId, () => CartItem(
        id: DateTime.now().toString(),
        title: title,
        price: price,
        quantity: 1
      ));
    }
    notifyListeners();
  }

}