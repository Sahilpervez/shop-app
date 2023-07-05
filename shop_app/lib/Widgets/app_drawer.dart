import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/AppUtils/styles.dart';
import 'package:shop_app/Screeens/cart_screen.dart';
import 'package:shop_app/Screeens/orders_screen.dart';
import 'package:shop_app/Screeens/user_product_screen.dart';

import '../Model/providers/auth.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          "https://images.newscientist.com/wp-content/uploads/2019/06/18142824/einstein.jpg",
                        ),
                        fit: BoxFit.cover,
                      ),
                      shape: BoxShape.circle,
                    ),
                    height: 60,
                    width: 60,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Hello Friend!!",
                        style: TextStyle(
                          fontFamily: AppStyle.defaultText,
                          fontSize: 20,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Color(0xff4EE753),
                              shape: BoxShape.circle,
                            ),
                            height: 11,
                            width: 11,
                          ),
                          const Text("Active"),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            // ListTile(
            //   style: ListTileStyle.drawer,
            //   leading: Icon(Icons.shop),
            //   title: Text("Shop"),
            //   onTap: () {
            //     Navigator.of(context).pushReplacementNamed('/');
            //   },
            // ),
            // Divider(),
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                child: Row(
                  children: [
                    Container(margin: const EdgeInsets.only(right: 30)
                        ,child: const Icon(Icons.shop,)),
                    const Text("Shop",style: TextStyle(fontSize: 20),),
                  ],
                ),
              ),
            ),
            const Divider(),
            // ListTile(
            //   leading: Icon(Icons.payment_rounded),
            //   title: Text("Orders"),
            //   onTap: () {
            //     Navigator.of(context)
            //         .pushReplacementNamed(OrdersScreen.namedRoute);
            //   },
            // ),
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(OrdersScreen.namedRoute);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                child: Row(
                  children: [
                    Container(margin: const EdgeInsets.only(right: 30)
                        ,child: const Icon(Icons.payment_rounded,),),
                    const Text("Your Orders",style: TextStyle(fontSize: 20),),
                  ],
                ),
              ),
            ),
            const Divider(),
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(CartScreen.routeName);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                child: Row(
                  children: [
                    Container(margin: const EdgeInsets.only(right: 30)
                      ,child: const Icon(Icons.shopping_cart,),),
                    const Text("Your Cart",style: TextStyle(fontSize: 20),),
                  ],
                ),
              ),
            ),
            const Divider(),
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(UserProductsScreen.routeName);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                child: Row(
                  children: [
                    Container(margin: const EdgeInsets.only(right: 30)
                      ,child: const Icon(Icons.inventory_2_rounded,),),
                    const Text("Your Products",style: TextStyle(fontSize: 20),),
                  ],
                ),
              ),
            ),
            const Divider(),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed("/");
                Provider.of<Auth>(context,listen: false).logout();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                child: Row(
                  children: [
                    Container(margin: const EdgeInsets.only(right: 30)
                      ,child: const Icon(Icons.logout_rounded,),),
                    const Text("Logout",style: TextStyle(fontSize: 20),),
                  ],
                ),
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
