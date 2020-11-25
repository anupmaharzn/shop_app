import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Provider/orderProvider.dart';
import 'package:shop_app/Widgets/app_drawer.dart';
import 'package:shop_app/Widgets/order_items.dart';

class Orderscreem extends StatelessWidget {
  static const routeName = '/Order-screen';

  @override
  Widget build(BuildContext context) {
    //final orderData = Provider.of<OrderProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        //use the to avoid stateful/rebuild and isloading ni afai handel vako xa change dependencies or delay haru use garnu parirako chaina
        body: FutureBuilder(
          future: Provider.of<OrderProvider>(context, listen: false)
              .fetchAndsetOrder(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshot.error != null) {
                //do error handling;
                return Center(child: Text('An error occurred!'));
              } else {
                return Consumer<OrderProvider>(
                  builder: (ctx, orderData, child) => ListView.builder(
                    itemBuilder: (ctx, i) => OrderedItems(orderData.orders[i]),
                    itemCount: orderData.orders.length,
                  ),
                );
              }
            }
          },
        ));
  }
}
