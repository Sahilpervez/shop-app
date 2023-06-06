import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/AppUtils/styles.dart';
import 'package:shop_app/Model/providers/orders.dart' show Orders;
import 'package:shop_app/Widgets/app_drawer.dart';
import 'package:shop_app/Widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  static const namedRoute = '/OrdersScreen';


  Future<void> _refreshOrders(BuildContext context) async {
    await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _refreshOrders(context),
      child: Scaffold(
        backgroundColor: AppStyle.bgColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Your Orders",
            style: TextStyle(
              fontFamily: AppStyle.defaultText,
              fontWeight: FontWeight.w900,
              fontSize: 30,
            ),
          ),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshot.error != null) {
                return Center(child: Text("An Error Occured"));
              } else {
                return Consumer<Orders>(builder: (ctx,orders,child) => ListView.builder(
                  itemCount: orders.items.length,
                  itemBuilder: (ctx, i) => OrderItem(order: orders.items[i]),
                ),);
              }
            }
          },
        ),
      ),
    );
  }
}
