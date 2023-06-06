import 'package:flutter/material.dart';
import 'package:shop_app/AppUtils/styles.dart';
import 'package:shop_app/Screeens/cart_screen.dart';
import 'package:shop_app/Screeens/orders_screen.dart';
import 'package:shop_app/Screeens/user_product_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
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
                      Text(
                        "Hello Friend!!",
                        style: TextStyle(
                          fontFamily: AppStyle.defaultText,
                          fontSize: 20,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xff4EE753),
                              shape: BoxShape.circle,
                            ),
                            height: 11,
                            width: 11,
                          ),
                          Text("Active"),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            Divider(),
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
              child: Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                  child: Row(
                    children: [
                      Container(margin: EdgeInsets.only(right: 30)
                          ,child: Icon(Icons.shop,)),
                      Text("Shop",style: TextStyle(fontSize: 20),),
                    ],
                  ),
                ),
              ),
            ),
            Divider(),
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
              child: Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                  child: Row(
                    children: [
                      Container(margin: EdgeInsets.only(right: 30)
                          ,child: Icon(Icons.payment_rounded,),),
                      Text("Your Orders",style: TextStyle(fontSize: 20),),
                    ],
                  ),
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(CartScreen.routeName);
              },
              child: Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                  child: Row(
                    children: [
                      Container(margin: EdgeInsets.only(right: 30)
                        ,child: Icon(Icons.shopping_cart,),),
                      Text("Your Cart",style: TextStyle(fontSize: 20),),
                    ],
                  ),
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(UserProductsScreen.routeName);
              },
              child: Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                  child: Row(
                    children: [
                      Container(margin: EdgeInsets.only(right: 30)
                        ,child: Icon(Icons.inventory_2_rounded,),),
                      Text("Your Products",style: TextStyle(fontSize: 20),),
                    ],
                  ),
                ),
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
