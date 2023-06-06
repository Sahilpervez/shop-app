import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/Model/providers/cart.dart';
import 'package:shop_app/Model/providers/products_provider.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.products,
    required this.amount,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get items {
    return [..._orders];
  }

  static const address = ProductsProvider.address;

  Future<void> addOrders(
    List<CartItem> cart,
    double price,
  ) async {
    final timeStamp = DateTime.now();
    try {
      final url = Uri.parse(
        "https://shopapp-9bf44-default-rtdb.firebaseio.com/orders.json",
      );
      final response = await http.post(
        url,
        body: json.encode({
          'amount': price,
          'dateTime': timeStamp.toIso8601String(),
          'products': cart.map((e) {
            return {
              'id': e.id,
              'productId': e.productId,
              'title': e.title,
              'quantity': e.quantity,
              'price': e.price,
            };
          }).toList(),
        }),
      );
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          products: cart,
          amount: price,
          dateTime: timeStamp,
        ),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchAndSetOrders() async {
    try {
      final url = Uri.parse(
        "$address/orders.json",
      );
      final response = await http.get(url);
      final responseData = json.decode(response.body);

      if (responseData != null) {
        responseData.forEach((key, value) {

          if (kDebugMode) {
            print(_orders.indexWhere((element) => element.id == key));
          }
          if ((_orders.indexWhere((element) => element.id == key)) == -1 ) {

            var _products = [];
            value['products'].forEach((e) {
              // if (_orders.indexWhere((element) => element.id == e['id']) != -1 ) {
              //   print("adding");
              //
              // } else {
              //   print("already Exists");
              // }
              _products.add(
                CartItem(
                  id: e['id'],
                  productId: e['productId'],
                  title: e['title'],
                  quantity: e['quantity'],
                  price: e['price'],
                ),
              );
            });
            final tempOrder = OrderItem(
              id: key,
              products: [..._products],
              amount: value['amount'],
              dateTime: DateTime.parse(value['dateTime']),
            );

            if (kDebugMode) {
              print("adding");
            }
            _orders.add(tempOrder);
          } else {
            if (kDebugMode) {
              print("already Exists");
            }
          }

        });
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      throw error;
    }
  }
}
