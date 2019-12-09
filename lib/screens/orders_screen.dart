import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders.dart' show Orders;
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const route = '/orders';

  @override
  Widget build(BuildContext context) {
    // final Orders orders = Provider.of<Orders>(context);
    print('build vorders');
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Order'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (_, dataSnapshot) {
          if(dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(),);
          } else {
            if(dataSnapshot.error != null) {
              return Center(
                child: Text('Error info'),
              );
            } else {
              return Consumer<Orders>(
                builder: (_, model, __) {
                  return ListView.builder(
                    itemCount: model.items.length,
                    itemBuilder: (_,index) => OrderItem(model.items[index])
                  );
                },
              );
            }
          }          
        },
      ),
    );
  }
}