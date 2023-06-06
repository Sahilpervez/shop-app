import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Model/product.dart';
import '../Model/providers/products_provider.dart';
import 'Product_Item.dart';

class ProductsGrid extends StatelessWidget {
  ProductsGrid(this._showOnlyFavourites);
  final _showOnlyFavourites;
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products = _showOnlyFavourites ? productsData.FavItems : productsData.items;
    return GridView.builder(
      primary: false,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        childAspectRatio: 3 / 5.1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        maxCrossAxisExtent: 300,
      ),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        // create: (c) => products[i],
        value: products[i],
        child: ProductItem(),
      ),
    );
  }
}
