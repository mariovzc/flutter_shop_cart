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
  List<OrderItem> _items = [];

  List<OrderItem> get items {
    return [..._items];
  }

  Future<void> fetchAndSetOrders() async {
    final _url = 'https://products-flutter-example.firebaseio.com/orders.json';
    final response = await http.get(_url);
    List<OrderItem> loadedOrders = [];

    final extractedData = json.decode(response.body) as Map<String ,dynamic>;
    if (extractedData == null) return;
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
        id: orderId,
        amount: orderData['amount'],
        dateTime: DateTime.parse(orderData['dateTime']),
        products: (orderData['products'] as List<dynamic>)
        .map((item) => CartItem(
          id: item['id'],
          price: item['price'],
          quantity: item['quantity'],
          title: item['title'],
        ))
        .toList()
      ));
    });
    _items = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final _url = 'https://products-flutter-example.firebaseio.com/orders.json';
    final timestamp = DateTime.now();
    try {
      final response = await http.post(
        _url,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts.map((cp) => {
              'id': cp.id,
              'title': cp.title,
              'quantity': cp.quantity,
              'price': cp.price
          }).toList(),
        }),
      );
      
      _items.insert(0, OrderItem(
        id: json.decode(response.body)['name'],
        products: cartProducts,
        amount: total,
        dateTime: DateTime.now()
      ));
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }


    notifyListeners();
  }
}