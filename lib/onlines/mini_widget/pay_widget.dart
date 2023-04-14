import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget PayWidget(
    BuildContext context, Map<String, dynamic> product, int index) {
  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
  return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Expanded( // Add this widget
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  children: [
                    Flexible(
                      child: Text(
                        "${product["nameproduct"]} Size ${product["size"]} x${product["amount"]}",
                        style: TextStyle(color: Colors.cyan, fontSize: 14),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                   product['sale']==0? Row(
                     crossAxisAlignment: CrossAxisAlignment.start,

                     children: [
                       Text("Đơn giá: ${myFormat.format(product["price"])}"),
                       SizedBox(width: 20,),
                       Text(
                           "Thành Tiền: ${myFormat.format(product["price"] * product["amount"])}")
                     ],
                   ):OverflowBar(
                     children: [ Text("Đơn giá: ${myFormat.format(product["price"]*(100-product['sale'])/100)} (Giá khuyến mãi)",style: TextStyle(color: Colors.red),),
                       Text(
                           "Thành Tiền: ${myFormat.format(product["price"]*(100-product['sale'])/100 * product["amount"])}")],
                   )
                  ],
                ),
              ),
            ),
          ],
        ),
      ));
}
