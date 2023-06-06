import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/AppUtils/styles.dart';
import 'dart:math';
import 'package:ionicons/ionicons.dart';
import 'package:shop_app/Screeens/product_detail_screen.dart';

import '../Model/product.dart';
import '../Model/providers/cart.dart';

class ProductItem extends StatelessWidget {
  int idx = Random().nextInt(50) % 4;

  @override
  Widget build(BuildContext context) {
    final prdct = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context);
    return LayoutBuilder(
      builder: (BuildContext ctx, BoxConstraints constraints) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailsScreen.routeName,
              arguments: prdct.id,
            );
          },
          child: Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 7, bottom: 7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xffd0cfcf),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: (prdct.discount != null)
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.end,
                  children: [
                    if( prdct.discount == 0)
                      Spacer(),
                    if (prdct.discount != null && prdct.discount != 0)
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Color(0xff50edf8),
                            borderRadius: BorderRadius.circular(9)),
                        child: Text(
                          "${prdct.discount?.toInt()}%",
                          style: TextStyle(
                            fontFamily: AppStyle.defaultText,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    Consumer<Product>(
                      builder: (ctx, prdct, child) => IconButton(
                        onPressed: () {
                          prdct.toggleFavouriteStatus();
                          print("favoutite");
                        },
                        icon: Icon(
                          prdct.isFavourite == true
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: constraints.maxWidth * 0.26,
                        backgroundColor: AppStyle.circleAvtarColors[idx],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: constraints.maxHeight * 0.3,
                        width: constraints.maxWidth * 0.7,
                        decoration: BoxDecoration(
                          // color: Colors.redAccent,
                          image: DecorationImage(
                              image: NetworkImage(
                                prdct.imageURL,
                              ),
                              fit: BoxFit.contain),
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      prdct.title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: AppStyle.defaultText,
                        fontSize: 20,
                        color: AppStyle.bigTextColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "\$ ",
                            style: TextStyle(
                              fontSize: 15,
                              color: AppStyle.bigTextColor,
                              fontFamily: AppStyle.defaultText,
                            ),
                          ),
                          TextSpan(
                            text: prdct.price.toString(),
                            style: const TextStyle(
                              fontSize: 20,
                              color: AppStyle.bigTextColor,
                              fontFamily: AppStyle.defaultText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          prdct.rating.toString(),
                          style:
                              TextStyle(fontSize: constraints.maxWidth * 0.09),
                        ),
                        Icon(Icons.star_rounded,
                            color: Colors.amber,
                            size: constraints.maxWidth * 0.13),
                        Icon(Icons.star_rounded,
                            color: Colors.amber,
                            size: constraints.maxWidth * 0.13),
                        Icon(Icons.star_rounded,
                            color: Colors.amber,
                            size: constraints.maxWidth * 0.13),
                        Icon(Icons.star_rounded,
                            color: Colors.amber,
                            size: constraints.maxWidth * 0.13),
                        Icon(Icons.star_half,
                            color: Colors.amber,
                            size: constraints.maxWidth * 0.13),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        cart.additems(prdct.id, prdct.price, prdct.title);
                        print(cart.numberOfItems);
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Added item to Cart!!",),
                            duration: Duration(seconds: 2),
                            action: SnackBarAction(
                              onPressed: (){
                                cart.removeItems(prdct.id);
                              },
                              label: "UNDO",
                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.shopping_cart_outlined),
                          Text("Add to Cart"),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}