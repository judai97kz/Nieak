import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

Widget MiniProduct(BuildContext context, Map<String, dynamic> shoes) {
  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
  return Container(
    decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(10)),
    child: Column(
      children: [
        Stack(
          children: [
            Align(
              child: Container(
                  height: 150,
                  width: 150,
                  child: Image.network(shoes["image"][0])),
            ),
            shoes['sale'] == 0
                ? SizedBox(
                    height: 0,
                  )
                : Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Container(
                        color: Colors.red,
                        height: 45,
                        width: 40,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                          child: Text(
                            "Sale ${shoes['sale']}%",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10),
                          ),
                        ),
                      ),
                    )),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(shoes["nameshoes"],overflow: TextOverflow.ellipsis,),
        ),
        SizedBox(
          height: 20,
        ),
        shoes['sale'] == 0
            ? Stack(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          "${myFormat.format(shoes["price"])}đ",
                          style: TextStyle(color: Colors.red),
                        ),
                      ))
                ],
              )
            : Stack(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          "Giá gốc: ${myFormat.format(shoes["price"])}đ",
                          style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.lineThrough),
                        ),
                      ))
                ],
              ),
        shoes['sale'] == 0
            ? SizedBox(
                height: 0,
              )
            : Stack(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(.0),
                        child: Text(
                          "Giá khuyến mãi: \n ${myFormat.format((shoes["price"] * (100 - shoes['sale'])) / 100)}đ",
                          style: TextStyle(color: Colors.red),
                        ),
                      ))
                ],
              ),
        shoes['sale'] == 0
            ? shoes['amount'] == 0
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Container(child: Text("Hết hàng")))
                : Align(
                    alignment: Alignment.centerLeft,
                    child: Container(child: Text("Còn hàng")))
            : SizedBox(
                height: 0,
              )
      ],
    ),
  );
}
