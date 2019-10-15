import 'package:flutter/foundation.dart';
import 'package:shop/providers/cart.dart';

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

  void addOrder(List<CartItem> cartProducts, double total) {
    _items.insert(0, OrderItem(
      id: DateTime.now().toString(),
      products: cartProducts,
      amount: total,
      dateTime: DateTime.now()
    ));
    notifyListeners();
  }
}