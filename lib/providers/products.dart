import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shop/providers/product.dart';
import 'package:http/http.dart' as http;
class Products with ChangeNotifier{
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  // bool _showFavoritesOnly = false;

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((item) => item.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere(
      (prod) => prod.id == id
    );
  }
  

  // void showFavoritesOnly(bool show) {
  //   print(show);
  //   _showFavoritesOnly= show;
  //   notifyListeners();
  // }
  
  Future<void> addProduct(Product product) {
    const url = 'https://products-flutter-example.firebaseio.com/products.json';
    return http.post(
      url,
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'isFavorite': product.isFavorite,
      }),
    ).then((response) {
      final _newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        id: json.decode(response.body)['name'],
        imageUrl: product.imageUrl,
      );
      _items.add(_newProduct);
      notifyListeners();
    }).catchError((error) {
      print(error);
      throw error;
    });
  }

  void updateProduct(String id, Product product) {
    final prodItems = _items.indexWhere((prod) => prod.id == id);
    if (prodItems > 0) {
      _items[prodItems] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String id){
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  } 
}