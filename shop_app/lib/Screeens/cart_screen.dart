import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/AppUtils/styles.dart';
import 'package:shop_app/Model/providers/orders.dart';
import 'package:shop_app/Model/providers/products_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shop_app/Screeens/products_overview_screen.dart';

import '../Model/providers/cart.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const routeName = "/cartScreen";
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final products = Provider.of<ProductsProvider>(context);
    final cartItems = cart.items;
    return Scaffold(
      backgroundColor: AppStyle.bgColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Cart",
          style: TextStyle(
            fontFamily: AppStyle.defaultText,
            fontSize: 30,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return (cartItems.isEmpty)
            ? Center(
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          height: MediaQuery.of(context).size.height * 0.5,
                          image: AssetImage(
                            "assets/CartIsEmpty.png",
                          ),
                        ),
                        const Text(
                          "Cart is Empty",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              fontFamily: AppStyle.defaultText),
                        ),
                        const Text(
                          "Add some items to cart",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              fontFamily: AppStyle.defaultText),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(ProductsOverviewScreen.route, (route) => false);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 4,),
                            child: Text(
                              "Go to Home Screen",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.blue
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(15),
                      children: [
                        ...cartItems.entries.map(
                          (entry) {
                            return ItemOfCart(
                              products: products,
                              cart: cart,
                              constraints: constraints,
                              entry: entry,
                            );
                          },
                        ).toList(),
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
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "Total : ",
                            style: TextStyle(
                                fontSize: 21, fontFamily: AppStyle.defaultText),
                          ),
                          // Spacer(),
                          Chip(
                            label: Text(
                              "\$${cart.totalAmount.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: AppStyle.themeColor,
                          ),
                          const Spacer(),
                          OrderButton(cart: cart),
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    super.key,
    required this.cart,
  });

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading == true)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrders(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );
              _isLoading = false;
              if (kDebugMode) {
                widget.cart.items.values.toList().forEach(
                  (element) {
                    if (kDebugMode) {
                      print(
                        "${element.id},${element.title},${element.price},${element.quantity}\n",
                      );
                    }
                  },
                );
                print(widget.cart.totalAmount);
              }
              widget.cart.clearCart();
            },
      child: (_isLoading == true)
          ? const Center(child: CircularProgressIndicator())
          : const Text(
              "ORDER NOW",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}

class ItemOfCart extends StatelessWidget {
  ItemOfCart({
    super.key,
    required this.products,
    required this.cart,
    required this.constraints,
    required this.entry,
  });

  final ProductsProvider products;
  final Cart cart;
  BoxConstraints constraints;
  MapEntry<String, CartItem> entry;

  // key: ValueKey(entry.value.id),
  // background: Container(
  // decoration: BoxDecoration(
  // color: Colors.red,
  // borderRadius: BorderRadius.circular(30),
  // ),

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (direction) {
        cart.removeBundle(entry.key);
      },
      key: ValueKey(entry.value.id),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text(
              "Are you sure?",
              style: TextStyle(fontFamily: AppStyle.defaultText),
            ),
            content: const Text(
              "Do you want to remove this item form Cart?",
              style: TextStyle(fontFamily: AppStyle.defaultText),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: const Text("Yes"),
              ),
            ],
          ),
        );
      },
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.delete,
                color: Colors.white,
                size: constraints.maxHeight * 0.045,
              ),
              Icon(
                Icons.delete,
                color: Colors.white,
                size: constraints.maxHeight * 0.045,
              ),
            ],
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        height: constraints.maxHeight * 0.24,
        padding: const EdgeInsets.all(7),
        margin: const EdgeInsets.symmetric(
          horizontal: 3,
          vertical: 5,
        ),
        width: constraints.maxWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        products.items
                            .firstWhere((element) => element.id == entry.key)
                            .imageURL,
                      ),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  width: constraints.maxHeight * 0.15,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      "${entry.value.title}",
                      style: const TextStyle(
                          fontFamily: AppStyle.defaultText,
                          color: AppStyle.bigTextColor,
                          fontSize: 23,
                          fontWeight: FontWeight.w600),
                    ),
                    AutoSizeText(
                      "\$${entry.value.price}",
                      style: const TextStyle(
                        fontFamily: AppStyle.defaultText,
                        color: AppStyle.bigTextColor,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            (constraints.maxHeight > 579)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: (constraints.maxWidth > 330)
                        ? [
                            IconButton(
                              onPressed: () {
                                cart.additems(entry.key, entry.value.price,
                                    entry.value.title);
                              },
                              icon: const Icon(
                                Icons.add_circle_rounded,
                                color: AppStyle.selectionColor,
                                size: 32,
                              ),
                            ),
                            AutoSizeText(
                              "${entry.value.quantity}",
                              style: const TextStyle(
                                fontFamily: AppStyle.defaultText,
                                fontSize: 23,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                cart.removeItems(entry.key);
                              },
                              style: IconButton.styleFrom(
                                shadowColor: Colors.grey,
                              ),
                              icon: const Icon(
                                Icons.remove_circle_rounded,
                                size: 28,
                              ),
                            ),
                          ]
                        : [
                            AutoSizeText(
                              "${entry.value.quantity}",
                              style: const TextStyle(
                                fontFamily: AppStyle.defaultText,
                                fontSize: 23,
                              ),
                            ),
                          ],
                  )
                : Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Row(
                      children: (constraints.maxWidth > 397)
                          ? [
                              IconButton(
                                onPressed: () {
                                  cart.additems(entry.key, entry.value.price,
                                      entry.value.title);
                                },
                                icon: const Icon(
                                  Icons.add_circle_rounded,
                                  color: AppStyle.selectionColor,
                                  size: 32,
                                ),
                              ),
                              SizedBox(
                                width: constraints.maxWidth * 0.015,
                              ),
                              AutoSizeText(
                                "${entry.value.quantity}",
                                style: const TextStyle(
                                  fontFamily: AppStyle.defaultText,
                                  fontSize: 23,
                                ),
                              ),
                              SizedBox(
                                width: constraints.maxWidth * 0.015,
                              ),
                              IconButton(
                                onPressed: () {
                                  cart.removeItems(entry.key);
                                },
                                icon: const Icon(
                                  Icons.remove_circle_rounded,
                                  size: 28,
                                ),
                              ),
                            ]
                          : [
                              AutoSizeText(
                                "${entry.value.quantity}",
                                style: const TextStyle(
                                  fontFamily: AppStyle.defaultText,
                                  fontSize: 23,
                                ),
                              ),
                            ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
