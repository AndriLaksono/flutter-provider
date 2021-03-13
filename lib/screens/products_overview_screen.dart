import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/cart.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import './cart_screen.dart';

enum FilterOptions {
  Favorites,
  ShowAll
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(child: Text('Favorite'), value: FilterOptions.Favorites,),
              PopupMenuItem(child: Text('Show All'), value: FilterOptions.ShowAll,),
            ]
          ),
          Consumer<Cart>(
            builder: (ctx, cart, ch) => Badge(
              child: ch, 
              value: cart.itemCount.toString()
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart), 
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              }
            ),
          ),
          SizedBox(width: 10,)
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}