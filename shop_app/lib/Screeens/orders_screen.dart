import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
          title: const Text(
            "Your Orders",
            style: TextStyle(
              fontFamily: AppStyle.defaultText,
              fontWeight: FontWeight.w900,
              fontSize: 30,
            ),
          ),
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.blue,));
            } else {
              if (dataSnapshot.error != null) {
                return const Center(child: Text("An Error Occured"));
              } else {
                return Consumer<Orders>(
                  builder: (ctx, orders, child) => (orders.items.length == 0)
                      ? Center(
                          child: SingleChildScrollView(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset(
                                "assets/OrdersNotFounnd.json",
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                              ),
                              Text(
                                "No Orders Found",
                                style: TextStyle(
                                    fontFamily: AppStyle.defaultText,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                        )
                      : ListView.builder(
                          itemCount: orders.items.length,
                          itemBuilder: (ctx, i) =>
                              OrderItem(order: orders.items[i]),
                        ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
