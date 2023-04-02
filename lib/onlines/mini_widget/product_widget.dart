import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

Widget MiniProduct(BuildContext context, Map<String, dynamic> shoes) {
  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.white60),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        children: [

          Container(
              height: 150, width: 150, child: Image.network(shoes["image"][0])),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(shoes["nameshoes"]),
          ),
          SizedBox(height: 20,),
          Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text("${myFormat.format(shoes["price"])}đ",style: TextStyle(color: Colors.red),),
                  ))
            ],
          ),
        ],
      ),
    ),
  );
}
