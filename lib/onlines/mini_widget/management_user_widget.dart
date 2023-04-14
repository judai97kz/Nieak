import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nieak/onlines/modelviews/home_modelview.dart';

Widget ManagementUserWidget(Map<String, dynamic> theuser) {
  var id = theuser['id'].toString().trim();
  var homestate = Get.put(HomeModelView());
  return Padding(
    padding: const EdgeInsets.all(2.0),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black)
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Mã khách hàng: ${theuser['id']}"),
            Text("Tên khách hàng: ${theuser['name']}"),
            Text("Điện thoại: ${theuser['phone']}"),
            Text("Mail: ${theuser['mail']}"),
            Text("Địa chỉ: ${theuser['address']}"),
            Text(theuser['disable']?'Tình trạng: Đã bị vô hiệu hóa':'Tình trạng: Tốt'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('user')
                            .doc(id)
                            .delete();
                        homestate.GetAllUser();
                      },
                      child: Text("Xóa người dùng")),
                  theuser['disable'] == true
                      ? ElevatedButton(
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('user')
                                .doc(id)
                                .update({'disable': false});
                            homestate.GetAllUser();
                          },
                          child: Text("Tắt vô hiệu hóa người dùng"))
                      : ElevatedButton(
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('user')
                                .doc(id)
                                .update({'disable': true});
                            homestate.GetAllUser();
                          },
                          child: Text("Vô hiệu hóa người dùng"))
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}
