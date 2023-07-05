import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shop_app/AppUtils/Badge.dart';
import 'package:shop_app/AppUtils/styles.dart';
import 'package:shop_app/Model/providers/cart.dart';
import 'package:shop_app/Screeens/cart_screen.dart';
import 'package:shop_app/Widgets/app_drawer.dart';
import '../Model/providers/products_provider.dart';
import '../Widgets/Products_grid.dart';

enum FilterOptions {
  Favourites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  static const route = "/ProductsOverviewScreen";

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  @override
  void initState() {
    // Provider.of<ProductsProvider>(context).fetchAndSetProducts();  // This won't work

    // Future.delayed(Duration.zero).then((value){
    //   Provider.of<ProductsProvider>(context).fetchAndSetProducts();
    // });

    // This was Method 1 But this is more of a hack than a Method
    // Another method will be using didChangeDepecdencies();
    // TODO: implement initState

    print("init State");
    super.initState();
  }

  bool _isInit = true;
  bool _isLoading = false;
  @override
  Future<void> didChangeDependencies() async {
    if (_isInit == true) {
      setState(() {
        _isLoading = true;
      });

      await Provider.of<ProductsProvider>(context)
          .fetchAndSetProducts()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    print("didDependenciesChange()");
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  var _showOnlyFavoutites = false;

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("Build");
    }
    final topBarItemsHere =
        Provider.of<ProductsProvider>(context, listen: false).TopBarItems;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "ShopApp",
          style: TextStyle(
            fontSize: 30,
            fontFamily: 'Varela',
            fontWeight: FontWeight.w900,
          ),
        ),
        // leading: IconButton(
        //   onPressed: (){
        //
        //   },
        //   icon: Icon(Icons.menu_rounded,size: 30,),
        // ),
        actions: [
          // PopupMenuButton(
          //   icon: Icon(Icons.more_vert),
          //   onSelected: (FilterOptions selectedValue) {
          //     print("$selectedValue");
          //     if (selectedValue == FilterOptions.Favourites) {
          //       // ProviderContainer.showFavouritesOnly();
          //       setState(() {
          //         _showOnlyFavoutites = true;
          //       });
          //     } else {
          //       // ProviderContainer.showAll();
          //       setState(() {
          //         _showOnlyFavoutites = false;
          //       });
          //     }
          //   },
          //   itemBuilder: (_) {
          //     return [
          //       PopupMenuItem(
          //         child: Text("Only Favourites"),
          //         value: FilterOptions.Favourites,
          //       ),
          //       PopupMenuItem(
          //         child: Text("Show All"),
          //         value: FilterOptions.All,
          //       ),
          //     ];
          //   },
          // ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
            child: Consumer<Cart>(
              builder: (_, cart, ch) => Badge_1(
                value: cart.numberOfItems.toString(),
                color: Colors.redAccent,
                child: ch!,
              ),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            ),
          ),
        ],
        // backgroundColor: Colors.red,
      ),
      drawer: const AppDrawer(),
      backgroundColor: const Color(0xfff3f2f2),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const AutoSizeText(
                  "Our Products",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontFamily: 'Rimouski',
                      fontWeight: FontWeight.w700),
                ),
                PopupMenuButton(
                  onSelected: (FilterOptions selectedValue) {
                    if (kDebugMode) {
                      print("$selectedValue");
                    }
                    if (selectedValue == FilterOptions.Favourites) {
                      // ProviderContainer.showFavouritesOnly();
                      setState(() {
                        _showOnlyFavoutites = true;
                      });
                    } else {
                      // ProviderContainer.showAll();
                      setState(() {
                        _showOnlyFavoutites = false;
                      });
                    }
                  },
                  itemBuilder: (_) {
                    return [
                      const PopupMenuItem(
                        value: FilterOptions.Favourites,
                        child: Text("Only Favourites"),
                      ),
                      const PopupMenuItem(
                        value: FilterOptions.All,
                        child: Text("Show All"),
                      ),
                    ];
                  },
                  child: Row(
                    children: const [
                      AutoSizeText(
                        "Filter by",
                        style: TextStyle(
                          color: Color(0xff605f5f),
                          fontSize: 15,
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down_rounded,
                        color: Color(0xff605F5F),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            TopBar(topBarItemsHere: topBarItemsHere),
            (_isLoading)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(right: 95),
                          height: 250,
                          width: 250,
                          child: Lottie.asset(
                              "assets/Loading_4.json",
                              fit: BoxFit.cover,
                              frameRate: FrameRate(59)),
                        ),
                      ),
                      const Text(
                        "Loading",
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: AppStyle.defaultText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                : ProductsGrid(_showOnlyFavoutites),
          ],
        ),
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    required this.topBarItemsHere,
  });

  final List<String> topBarItemsHere;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: max(60, MediaQuery.of(context).size.height * 0.09),
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.011,
      ),
      // margin: EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: topBarItemsHere.map((e) => TopBarElements(title: e)).toList(),
      ),
    );
  }
}

class TopBarElements extends StatelessWidget {
  final String title;
  const TopBarElements({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Color(0xffE1E1E1), spreadRadius: 3, blurRadius: 1),
        ],
        color: Colors.white,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Center(
        child: AutoSizeText(
          title,
        ),
      ),
    );
  }
}

// ListView(
// shrinkWrap: true,
// scrollDirection: Axis.horizontal,
// children: [
// TopBarElements(),
// TopBarElements(),
// TopBarElements(),
// TopBarElements(),
// TopBarElements(),
// ],
// ),
