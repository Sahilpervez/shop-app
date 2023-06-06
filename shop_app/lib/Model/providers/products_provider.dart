import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_app/Model/http_exceptions.dart';
import '../product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  var _isShowFavourites = false;

  static const address = String.fromEnvironment("ADDRESS");

  var TopBarItems = [
    "Sneakers",
    "Watches",
    "BackPack",
    "Torso",
    "Pants",
  ];

  Future<List> getData() async {
    final response = await http.get(Uri.parse(
        "$address/products_provider.json"));
    var responseData = json.decode(response.body);
    print(responseData);
    // will be used temporarily while creating the instance of raw maps
    var tempMap = {};
    // listOfMaps stores the final list of all the maps that will be used to create
    // instance of products and it will be populated in the further section while iterating
    // over the responseData and converting each and every response to the corrosponding map.
    var listOfMaps = [];
    if (responseData != null) {
      // iterate over each key value pair of response data json file using forEach() loop
      // and convert them into map that can be used to create instance of Product()
      responseData.forEach((key, value) {
        // store copy of all the body of data recieved from get request
        tempMap = {...responseData[key]};
        tempMap['key'] = key;
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

        print(tempMap);
        // add the raw map of product to the listOfMaps
        listOfMaps.add({...tempMap});
        tempMap.clear();
      });
    }
    print(listOfMaps);
    return listOfMaps;
    // print(responseData);
  }

  List<Product> get items {
    // var loadedData;
    // getData().then((value) {
    //   loadedData = [...value];
    //   print("inside then method of getData in getter items\n\n");
    //   loadedData.forEach((e) {
    //     if (_items.indexWhere((element) => element.id == e['key']) != -1) {
    //       print(
    //           'true${_items.indexWhere((element) => element.id == e['key'])}');
    //       print("ID : ${e['key']}");
    //       print(e['details']);
    //       print(e["title"]);
    //       print(e['discount']);
    //       print(e['imageURL']);
    //       print(e['price']);
    //       print(e['description']);
    //       print(e['attributes']);
    //     } else {
    //       List<dynamic> details = [...e['details']];
    //       print("false");
    //       print("rating: ${e['rating']}\n"
    //           "attributes: ${e["attributes"]}\n"
    //           "id: ${e['key']}\n"
    //           "title: ${e["title"]}\n"
    //           "description: ${e["description"]}\n"
    //           "price: ${e["price"]}\n"
    //           "imageURL: ${e["imageURL"]}\n"
    //           "isFavourite: ${e['isFavorite']}\n"
    //           "details: $details\n"
    //           "discount: ${e['discount']}\n");
    //       var hereProduct = Product(
    //         rating: e['rating'],
    //         attributes: {...e["attributes"]},
    //         id: e['key'],
    //         title: e["title"],
    //         description: e["description"],
    //         price: e["price"],
    //         imageURL: e["imageURL"],
    //         isFavourite: e['isFavorite'],
    //         details: [...details],
    //         discount: e['discount'],
    //       );
    //       _items.add(hereProduct);
    //     }
    //   });
    //   // return [..._items];
    // });
    // TODO: Implement returning with modified list of items
    return [..._items];
  }

  List<Product> get FavItems {
    return _items.where((element) => element.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  void ToggleFavourites(String id,bool favStatus){
    final url = Uri.parse("$address/products_provider/$id.json",);
    http.patch(url,body: json.encode({"isFavorite": favStatus}));
    notifyListeners();
  }

  // To fetch the data when loading the app
  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
      "$address/products_provider.json",
    );
    try {
      var loadedData;
      await getData().then((value) {
        loadedData = [...value];
        print("inside then method of getData in getter items\n\n");
        loadedData.forEach((e) {
          // if the Product is already present in the _items then just print the Product
          if (_items.indexWhere((element) => element.id == e['key']) != -1) {
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
          } else {
            // Else if the Product is not present in the _items then
            // print false and print the new to be added and convert them to
            // final instance of products
            List<dynamic> details = [];
            if(e['details'] != null){
              details = [...e['details']];
            }

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
            );
            // if not present in the _items then add the finally created
            // instance of Product() to _items
            _items.add(hereProduct);
          }
        });
      });
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> addProducts(Product newPrdct) async {
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
        "$address/products_provider.json",
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
            'isFavorite': prdct.isFavourite,
          },
        ),
      );
      if (kDebugMode) {
        print(json.decode(value.body));
      }
      // prdct.id = json.decode(value.body)['name'];
      final product_to_add = Product(
        rating: newPrdct.rating,
        attributes: {...newPrdct.attributes},
        id: json.decode(value.body)['name'],
        title: newPrdct.title,
        description: newPrdct.description,
        price: newPrdct.price,
        imageURL: newPrdct.imageURL,
        discount: newPrdct.discount,
        details: [...?newPrdct.details],
      );
      _items.add(product_to_add);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(Product newPrdct) async {
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
        "$address/products_provider/${prdct.id}.json",
      );
      final value = await http.patch(
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
            'isFavorite': prdct.isFavourite,
          },
        ),
      );

      var idx = _items.indexWhere((element) => element.id == prdct.id);
      print("\n$idx\n");
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
      print(error);
      throw error;
    }
  }

  Future<void> deleteProduct(String id) async {
    final existingProductIdx = _items.indexWhere((element) => element.id == id);
    Product? existingProduct = _items[existingProductIdx];
    _items.removeAt(existingProductIdx);
    notifyListeners();
    final url = Uri.parse(
      "$address/products_provider/$id.json",
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
