import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Model/providers/cart.dart';
import 'package:shop_app/Model/providers/orders.dart';
import 'package:shop_app/Screeens/cart_screen.dart';
import 'package:shop_app/Screeens/edit_by_user_screen.dart';
import 'package:shop_app/Screeens/add_product_screen.dart';
import 'package:shop_app/Screeens/login_screen.dart';
import 'package:shop_app/Screeens/orders_screen.dart';
import 'package:shop_app/Screeens/product_detail_screen.dart';
import 'package:shop_app/Screeens/products_overview_screen.dart';
import 'package:shop_app/Screeens/user_product_screen.dart';
import './Model/providers/products_provider.dart';
import 'Model/providers/auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          create: (ctx) => ProductsProvider([]),
          update: (BuildContext context, auth,
                  ProductsProvider? previousProducts) =>
              ProductsProvider(
            previousProducts != null ? previousProducts.items : [],
            token: auth.token,
            userId: auth.userId,
          ),
          // value: ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders([]),
          update: (BuildContext context, value, Orders? previous) => Orders(
            previous != null ? previous.items : [],
            token: value.token,
            userId: value.userId,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, authData, _) => MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
          ),
          home: (authData.isAuth)
              ? const ProductsOverviewScreen()
              : FutureBuilder(
                future: authData.autoLogin(),
                builder: (ctx, authResultSnapshot) => 
                (authResultSnapshot.connectionState != ConnectionState.waiting) ? 
                const LoginScreen()
                :const Scaffold(body: Center(
                  child: Text("Loading...."),
                ),)
                ),
          routes: {
            ProductDetailsScreen.routeName: (ctx) => const ProductDetailsScreen(),
            CartScreen.routeName: (ctx) => const CartScreen(),
            OrdersScreen.namedRoute: (ctx) => const OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => const UserProductsScreen(),
            AddProductScreen.routeName: (ctx) => const AddProductScreen(),
            EditByUserProductScreen.routeName: (ctx) =>
                const EditByUserProductScreen(),
            LoginScreen.route: (ctx) => const LoginScreen(),
            ProductsOverviewScreen.route: (ctx) => const ProductsOverviewScreen(),
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "ShopApp",
          style: TextStyle(
              fontSize: 25,
              fontFamily: 'Rimouski',
              fontWeight: FontWeight.w800),
        ),
        // backgroundColor: Colors.red,
      ),
      body: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontFamily: 'Rimouski',
          ),
        ),
      ),
    );
  }
}
