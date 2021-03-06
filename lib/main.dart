import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';
import './providers/products.dart';
import './providers/orders.dart';
import './providers/cart.dart';

import './screens/splash_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => null,
          update: (context, auth, previousProducts) => Products(
            auth.token,
            auth.userID,
            previousProducts == null ? [] : previousProducts.items
          ),
        ),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => null, 
          update: (context, auth, previousOrders) => Orders(
            auth.token,
            auth.userID,
            previousOrders == null ? [] : previousOrders.orders
          ),
        )
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.pink,
            accentColor: Colors.amber,
            fontFamily: 'Lato',
          ),
          debugShowCheckedModeBanner: false,
          home: auth.isAuth 
                ? ProductsOverviewScreen() 
                : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) => authResultSnapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          }
        ),
      ),
    );
  }
}