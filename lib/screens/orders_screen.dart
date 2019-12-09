import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders.dart' show Orders;
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const route = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    Future
      .delayed(Duration.zero)
      .then((_) async {
        // con false no es necesario el delayed
        _setLoading(true);
        await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
        _setLoading(false);
        
      });
    super.initState();
  }

  void _setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }


  @override
  Widget build(BuildContext context) {
    final Orders orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Order'),
      ),
      drawer: AppDrawer(),
      body: _isLoading 
      ? Center(child: CircularProgressIndicator(),)
      : ListView.builder(
        itemCount: orders.items.length,
        itemBuilder: (_,index) => OrderItem(orders.items[index]),
      )
    );
  }
}