import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/Provider/product_provider.dart';
import 'package:shop_app/Screens/edit_product_screen.dart';
import 'package:shop_app/Widgets/app_drawer.dart';
import 'package:shop_app/Widgets/userProductItem.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-product-screen';
  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<ProductProvider>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //final productsData = Provider.of<ProductProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Products'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.nameRoute);
              },
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _refreshProduct(context),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _refreshProduct(context),
                      child: Consumer<ProductProvider>(
                        builder: (ctx, productsData, _) => Padding(
                          padding: EdgeInsets.all(8),
                          child: ListView.builder(
                            itemBuilder: (_, i) => Column(
                              children: [
                                UserProductItem(
                                  id: productsData.items[i].id,
                                  title: productsData.items[i].title,
                                  imageUrl: productsData.items[i].imageUrl,
                                ),
                                Divider(),
                              ],
                            ),
                            itemCount: productsData.items.length,
                          ),
                        ),
                      ),
                    ),
        ));
  }
}
