import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nieak/onlines/modelviews/cart_modelview.dart';
import 'package:nieak/onlines/modelviews/user_state.dart';

Widget PayWidget(
    BuildContext context, Map<String, dynamic> product, int index) {
  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
  final cartModel = Get.put(CartModelView());
  final uidtemp = Get.put(UserState());
  return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Image.network(
                    product["image"],
                    height: 40,
                    width: 40,
                  )),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: Text(
                      "${product["nameproduct"]} Size ${product["size"]} x${product["amount"]}",
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    )),
                OverflowBar(
                  spacing: MediaQuery.of(context).size.width/5,
                  children: [
                    Text("Đơn giá: ${myFormat.format(product["price"])}"),
                    Text("Thành Tiền: ${myFormat.format(product["price"]*product["amount"])}")
                  ],
                )
              ],
            ),
          ],
        ),
      ));
}
