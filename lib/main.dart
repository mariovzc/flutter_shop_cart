import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/screens/orders_screen.dart';
import 'package:shop/screens/product_detail_screen.dart';

import 'providers/cart.dart';
import './providers/products.dart';
import 'screens/edit_product_screen.dart';
import 'screens/products_overview_screen.dart';
import 'screens/user_products.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Products(),),
        ChangeNotifierProvider.value(value: Cart(),),
        ChangeNotifierProvider.value(value: Orders(),),
      ],   
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato'
        ),
        home: ProductsOverViewScreen(),
        routes: {
          ProductDetailScreen.route: (_) => ProductDetailScreen(),
          CartScreen.route: (_) => CartScreen(),
          OrdersScreen.route: (_) => OrdersScreen(),
          UserProducts.route: (_) => UserProducts(),
          EditProductScreen.route: (_) => EditProductScreen(),
        },
      )
    );
  }
}