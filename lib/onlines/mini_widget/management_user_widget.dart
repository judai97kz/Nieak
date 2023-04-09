import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget ManagementUserWidget(Map<String,dynamic> theuser){
  return Container(child: Column(
    children: [
      Text(theuser['name']),
      Row(
        children: [
          ElevatedButton(onPressed: (){}, child: Text("Xóa người dùng")),
          ElevatedButton(onPressed: () async {

          }, child: Text("Vô hiệu hóa người dùng"))
        ],
      )
    ],
  ),);
}