import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/AppUtils/styles.dart';

import '../Model/providers/auth.dart';
import '../Model/providers/cart.dart';
import '../Model/providers/products_provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  // final String title;
  const ProductDetailsScreen({super.key});
  static const routeName = "/Product_Details";

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context);
    final id = ModalRoute.of(context)?.settings.arguments as String;
    final products = Provider.of<ProductsProvider>(context, listen: false);
    final cart = Provider.of<Cart>(context);
    final loadedProduct = products.findById(id);
    if (kDebugMode) {
      print("ID : $id");
      print(loadedProduct.details);
      print(loadedProduct.title);
      print(loadedProduct.discount);
      print(loadedProduct.imageURL);
      print(loadedProduct.price);
      print(loadedProduct.description);
      print("Attributes\n${loadedProduct.attributes}\n");
      if(loadedProduct.attributes.isNotEmpty){
        print(loadedProduct.attributes.values.last.runtimeType);
      }
    }

    final availableColors = loadedProduct.attributes.values.firstWhere((element) => element is Map<String,dynamic>, orElse: () => {});
    final availableColorsTitle = loadedProduct.attributes.keys.firstWhere((element) => loadedProduct.attributes[element] is Map<String,dynamic>, orElse: ()=> "");
    if (kDebugMode) {
      print(">>>> $availableColors");
      print(availableColors.isEmpty);
      print("****** $availableColorsTitle");
    }
    final listAttribute = loadedProduct.attributes.values.firstWhere((element) => element is List<dynamic>, orElse: ()=> []);
    if (kDebugMode) {
      print(">>>> $listAttribute");
    }
    final listTitle = loadedProduct.attributes.keys.firstWhere((element) => loadedProduct.attributes[element] is List<dynamic>, orElse: ()=> "");
    if (kDebugMode) {
      print("****** $listTitle");
    }
    // final availableColors =
    //     loadedProduct.attributes.values.last as Map<String, Color>;
    bool isFav = loadedProduct.isFavourite;
    final scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          loadedProduct.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: AppStyle.defaultText,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            onPressed: () {
              loadedProduct.toggleFavouriteStatus(authData.token,authData.userId);
              setState(() {
                isFav = !isFav;
              });
            },
            icon: Icon(
              isFav == false ? Icons.favorite_border : Icons.favorite,
              color: Colors.red,
              size: 30,
            ),
          ),
        ],
      ),
      backgroundColor: AppStyle.bgColor,
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  if (loadedProduct.discount != null && loadedProduct.discount !=0)
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xff50edf8),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Text(
                          "${loadedProduct.discount?.toInt()}%",
                          style: const TextStyle(
                            fontFamily: AppStyle.defaultText,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      shadowColor: Colors.grey,
                      elevation: 5,
                      child: Container(
                        height: (constraints.maxWidth > 500)
                            ? 330
                            : constraints.maxHeight * 0.45,
                        width: (constraints.maxWidth > 500)
                            ? 330 * 0.75
                            : constraints.maxHeight * 0.45 * 0.75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          image: DecorationImage(
                            image: NetworkImage(
                              loadedProduct.imageURL,
                            ),
                            fit: (constraints.maxWidth < 600)
                                ? BoxFit.cover
                                : BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        loadedProduct.title,
                        style: const TextStyle(
                          fontFamily: AppStyle.defaultText,
                          fontSize: 27,
                          color: AppStyle.bigTextColor,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                        size: 25,
                      ),
                      Text(
                        "(${loadedProduct.rating})",
                        style: const TextStyle(
                          fontFamily: AppStyle.defaultText,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    loadedProduct.description,
                    style: const TextStyle(
                        fontFamily: AppStyle.defaultText,
                        fontSize: 20,
                        color: AppStyle.themeColor),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if(listAttribute.isNotEmpty)
                    SizedBox(
                    height: constraints.maxHeight * 0.07 < 600 ? 50 : constraints.maxHeight * 0.07,
                    child: Row(
                      children: [
                        Center(
                          child: Text(
                            "$listTitle :",
                            style: const TextStyle(
                              fontFamily: AppStyle.defaultText,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Scrollbar(
                            controller: scrollController,
                            child: ListView(
                              controller: scrollController,
                              scrollDirection: Axis.horizontal,
                              children: [
                                ...listAttribute.map(
                                  (element) {
                                    return Card(
                                      elevation: 3,
                                      margin: const EdgeInsets.all(7),
                                      color: Colors.lightBlueAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                            vertical: 7,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            element,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontFamily: AppStyle.defaultText,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ).toList(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if(availableColors.isNotEmpty)
                    Text(
                      "$availableColorsTitle :",
                      style: const TextStyle(
                        fontFamily: AppStyle.defaultText,
                        fontSize: 20,
                      ),
                    ),
                  if(availableColors.isNotEmpty)
                    GridView(
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,childAspectRatio: 1,
                      maxCrossAxisExtent: 80,
                    ),
                    // physics: NeverScrollableScrollPhysics(),
                    children: [
                      ...availableColors.entries.map(
                        (e) => Card(
                          elevation: 5,
                          margin: const EdgeInsets.all(10),
                          shape: const CircleBorder(),
                            color: e.value,
                          child: Container(
                            decoration: const BoxDecoration(shape: BoxShape.circle),
                            height: 10,
                            width: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: min(constraints.maxWidth, 500),
              height: max(constraints.maxHeight * 0.108, 60),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: constraints.maxHeight < 600 ?const EdgeInsets.symmetric(horizontal: 15,vertical: 10) : const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "\$${loadedProduct.price.toString()}",
                      style: const TextStyle(
                          fontSize: 21, fontFamily: AppStyle.defaultText),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      icon: const Icon(Icons.shopping_cart),
                      onPressed: () {
                        cart.additems(loadedProduct.id, loadedProduct.price,
                            loadedProduct.title);
                      },
                      label: const Text(
                        "Add to Cart",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
