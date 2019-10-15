import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/widgets/product_item.dart';
import 'package:shop/providers/product.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final Products productsData = Provider.of<Products>(context);
    final List<Product> products = showFavs ? 
        productsData.favoriteItems : 
        productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (_, int index){
        return ChangeNotifierProvider<Product>.value(
          value: products[index],
          child: ProductItem(
            // id: products[index].id,
            // title: products[index].title,
            // imageUrl: products[index].imageUrl,
          )
        );
      },
    );
  }
}