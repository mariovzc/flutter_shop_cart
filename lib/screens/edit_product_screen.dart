import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';

class EditProductScreen extends StatefulWidget {

  static const String route = "/edit-product";

  EditProductScreen({Key key}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusnode = FocusNode();
  final _descriptionFocusnode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Product _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: ''
  );
  Map _initialValues = {
    'title': '',
    'description': '',
    'price': ''
  };
  bool _isInit = true;
  bool _isLoading = false;


  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.
                          of(context)
                          .settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(
          context,
          listen: false
        ).findById(productId);
        _initialValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusnode.dispose();
    _descriptionFocusnode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
    
  }

  void _updateImageUrl(){
    if(!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm()  async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    setState(() {_isLoading = true;});
    if(_editedProduct.id != null) {
      Provider.of<Products>(
        context,
        listen: false
      ).updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(
          context,
          listen: false
        )
        .addProduct(_editedProduct);
      } catch (e) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error Ocurred'),
            content: Text('Error in the form'),
            actions: <Widget>[
              FlatButton(
                child: Text('ok'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      } finally {
        setState(() {_isLoading = true;});
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading ?
      Center(
        child: CircularProgressIndicator(),
      ) :
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initialValues['title'],
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusnode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    title: value,
                    description: _editedProduct.description,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                    imageUrl: _editedProduct.imageUrl,
                    price: _editedProduct.price,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Provide a value';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initialValues['price'],
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusnode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusnode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                    imageUrl: _editedProduct.imageUrl,
                    price: double.parse(value),
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }

                  if (double.parse(value) <= 0) {
                    return 'Please enter a number greather than 0';
                  }

                  return null;
                },
              ),
              TextFormField(
                initialValue: _initialValues['description'],
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusnode,
                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    description: value,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                    imageUrl: _editedProduct.imageUrl,
                    price: _editedProduct.price,
                  );
                },
                validator: (value){
                  if (value.isEmpty) {
                    return 'Please provide a description';
                  }
                  if (value.length < 10) {
                    return 'should be at least 10 characters';
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                    ),
                    child: _imageUrlController.text.isEmpty ?
                    Text('Enter a Url'):
                    FittedBox(
                      child: Image.network(
                        _imageUrlController.text,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Image',
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) => _saveForm(),
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                          imageUrl: value,
                          price: _editedProduct.price,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'please provide a image url';
                        }
                        if (!value.startsWith('http') || !value.startsWith('https')) {
                          return 'Please enter a valid Url';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              )
            ],            
          ),
        ),
      ),
    );
  }
}