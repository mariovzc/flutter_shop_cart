import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {

  static const route = "/user-products";

  Future<void> _refreshProducts (BuildContext ctx) async {
    await Provider.of<Products>(ctx, listen: false).getAll();
  }

  @override
  Widget build(BuildContext context) {
    final Products products = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: (){
              Navigator.of(context).pushNamed(EditProductScreen.route);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: products.items.length,
            itemBuilder: (_,index) {
              return Column(
                children: <Widget>[
                  UserProductItem(
                    products.items[index].id,
                    products.items[index].title,
                    products.items[index].imageUrl,
                    //products.deleteProduct
                  ),
                  Divider(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}