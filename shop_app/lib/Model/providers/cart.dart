import 'package:flutter/material.dart';

class CartItem {
  final id;
  final title;
  late final quantity;
  final price;
  final productId;
  CartItem({
    required this.id,
    required this.productId,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  Map<String, CartItem> get items {
    return {..._items};
  }

  int get numberOfItems {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void additems(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (currItem) => CartItem(
          id: currItem.id,
          productId: currItem.productId,
          title: currItem.title,
          quantity: currItem.quantity + 1,
          price: currItem.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          productId: productId,
          title: title,
          quantity: 1,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  void removeItems(String productId) {
    if(_items[productId]?.quantity != 1){
      _items.update(
        productId,
            (value) => CartItem(
          id: productId,
          productId: productId,
          title: value.title,
          quantity: value.quantity - 1,
          price: value.price,
        ),
      );
    }else{
      _items.remove(productId);
    }
    notifyListeners();
  }

  void removeBundle(String productId){
    _items.remove(productId);
    notifyListeners();
  }
  void clearCart(){
    _items = {};
    notifyListeners();
  }

}
