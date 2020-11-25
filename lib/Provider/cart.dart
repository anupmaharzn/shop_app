import 'package:flutter/material.dart';

//cartItem  model
class CartItem {
  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
  final String id;
  final String title;
  final int quantity;
  final double price;
}

//cart ko lagi provider vayo
class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};
//copy of map key vanko  prodcut id hunxa ani value chai cart item
  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingcartItem) => CartItem(
                id: existingcartItem.id,
                title: existingcartItem.title,
                price: existingcartItem.price,
                quantity: existingcartItem.quantity + 1,
              ));
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
        productId,
        (existingcarditem) => CartItem(
            id: existingcarditem.id,
            title: existingcarditem.title,
            price: existingcarditem.price,
            quantity: existingcarditem.quantity - 1),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void removeitem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
