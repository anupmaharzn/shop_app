import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Provider/auth.dart';
import 'package:shop_app/Provider/cart.dart';
import 'package:shop_app/Provider/orderProvider.dart';
import 'package:shop_app/Provider/product_provider.dart';
import 'package:shop_app/Screens/auth_screen.dart';
import 'package:shop_app/Screens/cart_screen.dart';
import 'package:shop_app/Screens/edit_product_screen.dart';
import 'package:shop_app/Screens/order_screen.dart';
import 'package:shop_app/Screens/product_detail_screen.dart';
import 'package:shop_app/Screens/product_overview_screen.dart';
import 'package:shop_app/Screens/splash_screen.dart';
//import 'package:shop_app/Screens/product_overview_screen.dart';
import 'package:shop_app/Screens/user_productScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(),
        ),
        // ignore: missing_required_param
        ChangeNotifierProxyProvider<AuthProvider, ProductProvider>(
          update: (ctx, auth, previousProduct) => ProductProvider(
            auth.token,
            auth.userId,
            previousProduct == null ? [] : previousProduct.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartProvider(),
        ),
        // ignore: missing_required_param
        ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
          update: (ctx, auth, previousorder) => OrderProvider(
            auth.token,
            auth.userId,
            previousorder == null ? [] : previousorder.orders,
          ),
        ),
      ],
      //Provider version 4 paxi create use vako builder ko satta

      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato'),
          home: auth.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            Orderscreem.routeName: (ctx) => Orderscreem(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.nameRoute: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
