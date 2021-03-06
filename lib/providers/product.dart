import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

var baseUrl = 'flutter-purple-default-rtdb.firebaseio.com';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavValue(bool newVal) {
    isFavorite = newVal;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String authToken, String userID) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final url = Uri.https(baseUrl, '/userFavorites/$userID/$id.json', {'auth': authToken});
    try {
      final res = await http.put(url, body: json.encode({
        'isFavorite': isFavorite
      }));
      if (res.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (e) {
      _setFavValue(oldStatus);
    }
  }

}
