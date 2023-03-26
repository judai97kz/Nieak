import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget MiniProduct(BuildContext context, Map<String, dynamic> shoes) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black)
      ),
      child: Column(
        children: [
          Text(shoes["nameshoes"]),
          Container(
              height: 150, width: 150, child: Image.network(shoes["image"][0]))
        ],
      ),
    ),
  );
}
