import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';

class ProductDetailScreen extends StatelessWidget {

  static const route = '/product-detail';
  @override
  Widget build(BuildContext context) {
    final String productID = ModalRoute
                              .of(context)
                              .settings.arguments as String;
    
    final Product product = Provider.of<Products>(
      context,
      listen: false
    ).findById(productID);

    // TODO: refresh when favorite button is pressed

    //final Product product = Provider.of<Product>(context, listen: false);
    
    final Cart cart = Provider.of<Cart>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10,),
            Text(
              '\$${product.price}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                product.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),            
          ],
        ),
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          RaisedButton(
            child: product.isFavorite ?
            Icon(
              Icons.favorite,
              color: Theme.of(context).primaryTextTheme.title.color,
            ) :
            Icon(
              Icons.favorite_border,
              color: Theme.of(context).primaryTextTheme.title.color
            ),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              product.toggleFavoriteStatus();
              print(product.isFavorite);
            },
          ),                
          RaisedButton(
            child: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).primaryTextTheme.title.color,
            ),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              cart.addItem(
                product.id,
                product.price,
                product.title
              );
            },
          ),
        ],
      ),
    );
  }
}