import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_app/Model/http_exceptions.dart';
import '../product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  static const address = String.fromEnvironment("ADDRESS");

  var TopBarItems = [
    "Sneakers",
    "Watches",
    "BackPack",
    "Torso",
    "Pants",
  ];

  final String? token;
  final String? userId;
  ProductsProvider(this._items, {this.token, this.userId});

  Future<List> getData([bool filterByUser = false]) async {
    
    String filterString =
     filterByUser ?
    'orderBy="creatorId"&equalTo="$userId"' :
     "";
    
    final response = await http
        .get(Uri.parse('$address/products_provider.json?auth=$token&$filterString'));
    var responseData = json.decode(response.body);
    if (kDebugMode) {
      print(responseData);
    }
    // will be used temporarily while creating the instance of raw maps
    var tempMap = {};
    // listOfMaps stores the final list of all the maps that will be used to create
    // instance of products and it will be populated in the further section while iterating
    // over the responseData and converting each and every response to the corrosponding map.
    var listOfMaps = [];
    if (responseData != null) {
      final fav = await http
          .get(Uri.parse("$address/userFavourites/$userId.json?auth=$token"));
      final favData = json.decode(fav.body);
      // iterate over each key value pair of response data json file using forEach() loop
      // and convert them into map that can be used to create instance of Product()
      responseData.forEach((key, value) {
        // store copy of all the body of data recieved from get request
        tempMap = {...responseData[key]};
        tempMap['key'] = key;
        tempMap['isFavorite'] =
            (favData != null && favData.containsKey(key) && favData[key] == true)
                ? true
                : false;
        Map<String, dynamic> attribute =
            tempMap['attributes'] as Map<String, dynamic>;
        Map<String, dynamic> tempColors = attribute.values.firstWhere(
            (element) => element is Map<String, dynamic>,
            orElse: () => {});

        // make a copy of tempColors which is simply a map of Color name with hexCode
        var here = {...tempColors};
        // Convert the tempColors map to a map of ColorName and Color()
        // by iterating over the tempColors and modifying it using forEach loop
        here.forEach((key, value) {
          tempColors[key] = Color(int.parse(value));
        });

        if (kDebugMode) {
          print(tempMap);
        }
        // add the raw map of product to the listOfMaps
        listOfMaps.add({...tempMap});
        tempMap.clear();
      });
    }
    if (kDebugMode) {
      print(listOfMaps);
    }
    return listOfMaps;
    // print(responseData);
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get userItems{
    return [..._items.where((element) => element.creatorId == userId).toList()];
  }


  List<Product> get FavItems {
    return _items.where((element) => element.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  void ToggleFavourites(String id, bool favStatus) {
    final url = Uri.parse(
      "$address/products_provider/$id.json?auth=$token",
    );
    http.patch(url, body: json.encode({"isFavorite": favStatus}));
    notifyListeners();
  }

  // To fetch the data when loading the app
  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    // _items = [];
    try {
      List<dynamic> loadedData;
      await getData(filterByUser).then((value) {
        loadedData = [...value];
        if (kDebugMode) {
          print("inside then method of getData in getter items\n\n");
        }
        if (kDebugMode) {
          print(1);
        }
        for (var e in loadedData) {
          // if the Product is already present in the _items then just print the Product
          if (_items.indexWhere((element) => element.id == e['key']) != -1) {
            if (kDebugMode) {
              print(
                  'true${_items.indexWhere((element) => element.id == e['key'])}');
              print("ID : ${e['key']}");
              print(e['details']);
              print(e["title"]);
              print(e['discount']);
              print(e['imageURL']);
              print(e['price']);
              print(e['description']);
              print(e['attributes']);
            }
          } else {
            // Else if the Product is not present in the _items then
            // print false and print the new to be added and convert them to
            // final instance of products
            List<dynamic> details = [];
            if (e['details'] != null) {
              details = [...e['details']];
            }

            
            if (kDebugMode) {
              print("false");
              print("rating: ${e['rating']}\n"
                "attributes: ${e["attributes"]}\n"
                "id: ${e['key']}\n"
                "title: ${e["title"]}\n"
                "description: ${e["description"]}\n"
                "price: ${e["price"]}\n"
                "imageURL: ${e["imageURL"]}\n"
                "isFavourite: ${e['isFavorite']}\n"
                "details: $details\n"
                "discount: ${e['discount']}\n");
            }

            // Converting each raw map to Products
            var hereProduct = Product(
              rating: e['rating'],
              attributes: {...e["attributes"]},
              id: e['key'],
              title: e["title"],
              description: e["description"],
              price: e["price"],
              imageURL: e["imageURL"],
              isFavourite: e['isFavorite'],
              details: [...details],
              discount: e['discount'],
              creatorId: e['creatorId']
            );
            // if not present in the _items then add the finally created
            // instance of Product() to _items
            _items.add(hereProduct);
          
          }
        }
      });
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  Future<void> addProducts(Product newPrdct) async {
    if (kDebugMode) {
      print(
      ">>>>>>>>>  Product Before Adding"
      "id: ${newPrdct.id}\n"
      "title: ${newPrdct.title}\n"
      "price: ${newPrdct.price}\$\n"
      "description: ${newPrdct.description}\n"
      "discount: ${newPrdct.discount}%\n"
      "imageURL: ${newPrdct.imageURL}\n"
      "rating: ${newPrdct.rating}\n"
      "details: ${newPrdct.details}\n"
      "attributes: ${newPrdct.attributes}\n",
    );
    }
    // var idx = _items.indexWhere((element) => element.id == newPrdct.id);
    final prdct = Product(
      rating: newPrdct.rating,
      attributes: {...newPrdct.attributes},
      id: newPrdct.id,
      title: newPrdct.title,
      description: newPrdct.description,
      price: newPrdct.price,
      imageURL: newPrdct.imageURL,
      discount: newPrdct.discount,
      details: [...?newPrdct.details],
      creatorId : userId!,
    );

    var titleOfColors = prdct.attributes.keys.firstWhere(
      (element) => prdct.attributes[element] is Map<String, dynamic>,
    );
    Map<String, dynamic> mapOfColors = {
      ...prdct.attributes.values.firstWhere(
        (element) => element is Map<String, dynamic>,
      ) as Map<String, dynamic>
    };

    mapOfColors.forEach((key, value) {
      int idx = value.toString().indexOf('0x');
      String replacement = value.toString().substring(idx, idx + 10);
      // String replacement = value.toString();
      mapOfColors.update(key, (value) => replacement);
    });

    var tempAttributes = {...prdct.attributes};
    tempAttributes.update(titleOfColors, (value) => mapOfColors);
    try {
      final url = Uri.parse(
        "$address/products_provider.json?auth=$token",
      );
      final value = await http.post(
        url,
        body: json.encode(
          {
            // 'id': prdct.id,
            'title': prdct.title,
            'description': prdct.description,
            'price': prdct.price,
            'imageURL': prdct.imageURL,
            'discount': prdct.discount,
            'rating': prdct.rating,
            'details': [...?prdct.details],
            'attributes': {...tempAttributes},
            'creatorId' : userId ,
            // 'isFavorite': prdct.isFavourite,
          },
        ),
      );
      if (kDebugMode) {
        print(json.decode(value.body));
      }
      // prdct.id = json.decode(value.body)['name'];
      final productToAdd = Product(
        rating: newPrdct.rating,
        attributes: {...newPrdct.attributes},
        id: json.decode(value.body)['name'],
        title: newPrdct.title,
        description: newPrdct.description,
        price: newPrdct.price,
        imageURL: newPrdct.imageURL,
        discount: newPrdct.discount,
        details: [...?newPrdct.details],
        creatorId: userId!,
      );
      _items.add(productToAdd);
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  Future<void> updateProduct(Product newPrdct) async {
    if (kDebugMode) {
      print(
      ">>>>>>>>>  Product Before replacing"
      "id: ${newPrdct.id}\n"
      "title: ${newPrdct.title}\n"
      "price: ${newPrdct.price}\$\n"
      "description: ${newPrdct.description}\n"
      "discount: ${newPrdct.discount}%\n"
      "imageURL: ${newPrdct.imageURL}\n"
      "rating: ${newPrdct.rating}\n"
      "details: ${newPrdct.details}\n"
      "attributes: ${newPrdct.attributes}\n",
    );
    }
    final prdct = Product(
      rating: newPrdct.rating,
      attributes: {...newPrdct.attributes},
      id: newPrdct.id,
      title: newPrdct.title,
      description: newPrdct.description,
      price: newPrdct.price,
      imageURL: newPrdct.imageURL,
      discount: newPrdct.discount,
      details: [...?newPrdct.details],
      creatorId: userId!,
    );

    var titleOfColors = prdct.attributes.keys.firstWhere(
      (element) => prdct.attributes[element] is Map<String, dynamic>,
    );
    Map<String, dynamic> mapOfColors = {
      ...prdct.attributes.values.firstWhere(
        (element) => element is Map<String, dynamic>,
      ) as Map<String, dynamic>
    };

    mapOfColors.forEach((key, value) {
      int idx = value.toString().indexOf('0x');
      String replacement = value.toString().substring(idx, idx + 10);
      // String replacement = value.toString();
      mapOfColors.update(key, (value) => replacement);
    });

    var tempAttributes = {...prdct.attributes};
    tempAttributes.update(titleOfColors, (value) => mapOfColors);
    try {
      final url = Uri.parse(
        "$address/products_provider/${prdct.id}.json?auth=$token",
      );
      await http.patch(
        url,
        body: json.encode(
          {
            // 'id': prdct.id,
            'title': prdct.title,
            'description': prdct.description,
            'price': prdct.price,
            'imageURL': prdct.imageURL,
            'discount': prdct.discount,
            'rating': prdct.rating,
            'details': [...?prdct.details],
            'attributes': {...tempAttributes},
            // 'isFavorite': prdct.isFavourite,
          },
        ),
      );

      var idx = _items.indexWhere((element) => element.id == prdct.id);
      if (kDebugMode) {
        print("\n$idx\n");
      }
      final finalprdct = Product(
        rating: prdct.rating,
        attributes: {...prdct.attributes},
        id: prdct.id,
        title: prdct.title,
        description: prdct.description,
        price: prdct.price,
        imageURL: prdct.imageURL,
        discount: prdct.discount,
        details: [...?prdct.details],
        isFavourite: _items[idx].isFavourite,
        creatorId: userId!,
      );
      _items.replaceRange(idx, idx + 1, [finalprdct]);
      if (kDebugMode) {
        print(
          ">>>>>>>>> Product After replacing"
          "id: ${finalprdct.id}\n"
          "title: ${finalprdct.title}\n"
          "price: ${finalprdct.price}\$\n"
          "description: ${finalprdct.description}\n"
          "discount: ${finalprdct.discount}%\n"
          "imageURL: ${finalprdct.imageURL}\n"
          "rating: ${finalprdct.rating}\n"
          "details: ${finalprdct.details}\n"
          "attributes: ${finalprdct.attributes}\n",
        );
      }
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  Future<void> deleteProduct(String id) async {
    final existingProductIdx = _items.indexWhere((element) => element.id == id);
    Product? existingProduct = _items[existingProductIdx];
    _items.removeAt(existingProductIdx);
    notifyListeners();
    final url = Uri.parse(
      "$address/products_provider/$id.json?auth=$token",
    );
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIdx, existingProduct);
      notifyListeners();
      throw HttpException("Could not delete product");
    }
    existingProduct = null;
  }
}
