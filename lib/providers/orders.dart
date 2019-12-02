import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shop/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime
  });
}

class Orders  with ChangeNotifier{
  List<OrderItem> _items = [
    OrderItem(
      id: DateTime.now().toString(),
      dateTime: DateTime.now(),
      amount: 2000,
      products: [
        CartItem(
          id: DateTime.now().toString(),
          price: 2000,
          quantity: 1,
          title: 'Item',
        )
      ]
    )
  ];

  List<OrderItem> get items {
    return [..._items];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final _url = 'https://products-flutter-example.firebaseio.com/products.json';

    _items.insert(0, OrderItem(
      id: DateTime.now().toString(),
      products: cartProducts,
      amount: total,
      dateTime: DateTime.now()
    ));

    try {
      final response = await http.post(
        _url,
        body: json.encode({
        }),
      );
      final _newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        id: json.decode(response.body)['name'],
        imageUrl: product.imageUrl,
      );
      _items.add(_newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }


    notifyListeners();
  }
}