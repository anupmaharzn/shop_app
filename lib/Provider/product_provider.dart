import 'dart:convert';

import 'package:flutter/Material.dart';
import 'package:shop_app/Provider/product.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exceptions.dart';

class ProductProvider with ChangeNotifier {
  ProductProvider(this.authToken, this.userId, this._items);
  final String authToken;
  final String userId;
  //defining List of Products (private )
  List<Product> _items = [
    //fetech gareko data yeta //dummy removed
  ];

  //Private so can be access from out side so set getter so to avoide direct access
  //return copy of item [..._items]
  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((proditems) => proditems.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

//hamro _item maa fetch garnu paryo
  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : [];
    try {
      var url =
          'https://shop-app-6d524.firebaseio.com/products.json?auth=$authToken&$filterString';
      final response = await http.get(url);
      print(json..decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) {
        return;
      }
      url =
          'https://shop-app-6d524.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favortieData = json.decode(favoriteResponse.body);
      final List<Product> loadedProdcuts = [];
      extractedData.forEach((prodid, proddata) {
        loadedProdcuts.add(Product(
            id: prodid,
            title: proddata['title'],
            price: proddata['price'],
            isFavorite:
                favortieData == null ? false : favortieData['prodid'] ?? false,
            description: proddata['description'],
            imageUrl: proddata['imageUrl']));
      });
      _items = loadedProdcuts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://shop-app-6d524.firebaseio.com/products.json?auth=$authToken';

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'creatorId': userId,
        }),
      );

      //after post then  device memory maa save hunxa
      print(json.decode(response.body));
      final newprodcut = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newprodcut);
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://shop-app-6d524.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print("...");
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://shop-app-6d524.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpExceptions('Could not delete product');
    }
    existingProduct = null;
  }
}
