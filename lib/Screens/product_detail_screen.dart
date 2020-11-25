import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Provider/product_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/Product-Detail';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments
        as String; //id aako product item bata
    final loadedProduct =
        Provider.of<ProductProvider>(context).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: Center(
        child: Text('YETAAA'),
      ),
    );
  }
}
