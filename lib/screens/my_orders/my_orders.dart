import 'package:fassla_consumer/states/OrderRepository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';

class MyOrders extends StatefulWidget {
  static const routeName = "/my-orders";

  const MyOrders({Key? key}) : super(key: key);

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders"),
      ),
      body: FutureBuilder(
        future: getMyOrders(),
        builder:
            (BuildContext context, AsyncSnapshot<List<MyOrderModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          List<MyOrderModel> myOrdersList = snapshot.data ?? [];

          if (myOrdersList.isEmpty) {
            return Center(child: Text("You haven't placed an order yet..."));
          }

          return buildOrderList(myOrdersList);
        },
      ),
    );
  }
}

Widget buildOrderList(List<MyOrderModel> list) {
  // return orderTile(list[0]);
  // return orderTile2(list[0]);

  return ListView.builder(
    itemCount: list.length,
    itemBuilder: (BuildContext context, int index) {
      var order = list[index];
      return orderTile(order);
    },
  );
}

Widget orderTile(MyOrderModel myOrder) {
  var status = myOrderStatusMap[myOrder.status] ?? "";
  var time = myOrder.timestamp.toDate();
  final DateFormat dayFormatter = DateFormat('d MMMM y');
  final DateFormat timeFormatter = DateFormat('jm');
  final String placedAtDate = dayFormatter.format(time);
  final String placedAtTime = timeFormatter.format(time);

  return Card(
    margin: EdgeInsets.all(16),
    elevation: 10,
    child: Container(
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ORDER #${myOrder.orderId}",
            style: TextStyle(fontWeight: FontWeight.w300),
          ),
          ListTile(
            title: Text("Status"),
            trailing: Text(status),
          ),
          for (var prod in myOrder.cartModelList)
            ListTile(
              isThreeLine: true,
              title: Text(prod.productDoc['Product']),
              subtitle: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Quantity: " + prod.quantity.toString()),
                  Text("Weight: " + prod.weight),
                  Text(
                      "₹ ${prod.productDoc["price"]} / ${prod.productDoc["unit"]}"),
                ],
              ),
              leading: CircleAvatar(
                backgroundImage: Image.network(prod.productDoc["image"]).image,
              ),
              trailing: Text(prod.finalPrice.toString()),
              // contentPadding: EdgeInsets.only(bottom: 4),
              minVerticalPadding: 5,
            ),
          ListTile(
            title: Text("Total"),
            trailing: Text(myOrder.cart_price.toString()),
          ),
          ListTile(
            title: Text("Order placed on $placedAtDate at $placedAtTime."),
          ),
        ],
      ),
    ),
  );
}

Widget orderTile2(MyOrderModel myOrder) {
  return Card(
    child: Column(
      children: [
        Text("Order Id: ${myOrder.orderId}"),
        for (var m in myOrder.cartModelList)
          ListTile(
            contentPadding: EdgeInsets.all(4),
            leading: Text(m.quantity.toString()),
            title: Text(m.productDoc["Product"].toString()),
            trailing: Text(m.finalPrice.toString()),
          ),
        ListTile(
          title: Text("Status"),
          trailing: Text(myOrder.status.toString()),
        ),
      ],
    ),
  );
}
