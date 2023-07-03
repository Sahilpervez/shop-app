import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shop_app/Model/providers/products_provider.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageURL;
  final double? discount;
  final List<String>? details;
  final double rating;
  final Map<String, dynamic> attributes;
  bool isFavourite;
  String? fireBaseId;

  Product({
    required this.rating,
    required this.attributes,
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.details,
    this.fireBaseId,
    required this.imageURL,
    this.discount = null,
    this.isFavourite = false,
  });
  static const address = ProductsProvider.address;
  Future<void> toggleFavouriteStatus(String? token, String? userId) async {
    isFavourite = !isFavourite;
    print("$address/userFavourites/$userId/$id.json?auth=$token");
    final url = Uri.parse(
      "$address/userFavourites/$userId/$id.json?auth=$token",
    );
    final response =
        await http.put(url, body: json.encode(isFavourite));
    print(response.body);
    notifyListeners();
  }
}
