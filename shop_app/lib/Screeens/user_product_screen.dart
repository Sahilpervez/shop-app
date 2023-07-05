import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/AppUtils/styles.dart';
import 'package:shop_app/Model/product.dart';
import 'package:shop_app/Model/providers/products_provider.dart';
import 'package:shop_app/Screeens/edit_by_user_screen.dart';
import 'package:shop_app/Screeens/add_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);
  static const routeName = "/UserProductsScreen";

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    final prdcts =
        Provider.of<ProductsProvider>(context, listen: false).userItems;
    if (kDebugMode) {
      print("1");
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Your Products",
          style: TextStyle(
              fontFamily: AppStyle.defaultText,
              fontWeight: FontWeight.w600,
              fontSize: 28),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(AddProductScreen.routeName);
            },
          )
        ],
      ),
      backgroundColor: AppStyle.bgColor,
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) => (snapshot.connectionState ==
                ConnectionState.waiting)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _refreshProducts(context),
                child: Consumer<ProductsProvider>(
                  builder: (ctx, productsData, _) => (productsData
                              .userId!.isNotEmpty &&
                          prdcts.isNotEmpty)
                      ? GridView(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            childAspectRatio: 5 / 1.9,
                            maxCrossAxisExtent: 500,
                            mainAxisSpacing: 7,
                            crossAxisSpacing: 10,
                            // mainAxisExtent: 150,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          children: [
                            ...productsData.userItems
                                .map(
                                  (e) => LayoutBuilder(
                                    builder: (BuildContext context,
                                        BoxConstraints constraints) {
                                      return UserProductWidget(
                                        constraints: constraints,
                                        e: e,
                                        scaffold: ScaffoldMessenger.of(context),
                                      );
                                    },
                                  ),
                                )
                                .toList(),
                          ],
                        )
                      : Center(
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 250,
                              width: 250,
                              child: Image(
                                image: AssetImage(
                                  "assets/Product_not_found.gif",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Text(
                              "You don't own/sell any products",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  fontFamily: AppStyle.defaultText),
                            ),
                          ],
                        )),
                ),
              ),
      ),
    );
  }
}

class UserProductWidget extends StatelessWidget {
  const UserProductWidget({
    super.key,
    required this.constraints,
    required this.e,
    required this.scaffold,
  });
  final scaffold;
  final BoxConstraints constraints;
  final Product e;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: (constraints.maxWidth > 326)
              ? MainAxisAlignment.spaceAround
              : MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        e.imageURL,
                      ),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 10,
                          spreadRadius: 0.2,
                          offset: Offset(0, 2))
                    ],
                  ),
                  height: constraints.maxHeight - 30,
                  width: (constraints.maxHeight - 40) * 3 / 4,
                  margin: const EdgeInsets.only(right: 20),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e.title,
                      style: const TextStyle(
                          fontSize: 20,
                          fontFamily: AppStyle.defaultText,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: constraints.maxWidth -
                          constraints.maxHeight * 3 / 3.5 * 1.5,
                      child: Text(
                        e.description,
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: AppStyle.defaultText,
                          fontWeight: FontWeight.w500,
                          overflow: (constraints.maxWidth < 320)
                              ? TextOverflow.ellipsis
                              : TextOverflow.visible,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // if (constraints.maxWidth > 326)
            Column(
              mainAxisAlignment: (constraints.maxWidth <= 326)
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        EditByUserProductScreen.routeName,
                        arguments: e.id,
                      );
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.black,
                    )),
                if (constraints.maxWidth > 326)
                  Text(
                    "\$${e.price}",
                    style: const TextStyle(
                      fontFamily: AppStyle.defaultText,
                    ),
                  ),
                IconButton(
                    onPressed: () async {
                      try {
                        await Provider.of<ProductsProvider>(context,
                                listen: false)
                            .deleteProduct(e.id);
                      } catch (error) {
                        scaffold.showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Couldn't delete the item",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
