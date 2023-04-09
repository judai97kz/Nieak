import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nieak/onlines/modelviews/home_modelview.dart';

Widget ManagementProductWidget(Map<String, dynamic> product) {
  final homeModel = Get.put(HomeModelView());
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Column(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text('Mã sản phẩm: ${product['idshoes']}'),
              )),
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text('Tên sản phẩm: ${product['nameshoes']}'),
              )),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              child: Row(
                children: [
                  Image.network(
                    product['image'][0],
                    height: 60,
                    width: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Kích thước: ${product['minsize']}-${product['maxsize']}'),
                        Text('Đơn giá: ${product['price']}'),
                        Text('Số lượng: ${product['amount']}')
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 25,
                    color: Colors.red,
                    child: Center(child: Text("Sửa")),
                  ),
                )),
                Expanded(
                    child: GestureDetector(
                  onTap: () async {
                    final querySnapshot = await FirebaseFirestore.instance
                        .collection('product')
                        .where('idshoes', isEqualTo: product['idshoes'])
                        .get();
                    final docsList = querySnapshot.docs;
                    for (final doc in docsList) {
                      await doc.reference.delete();
                    }
                    homeModel.GetAllProduct();
                  },
                  child: Container(
                    height: 25,
                    color: Colors.green,
                    child: Center(child: Text("Xóa")),
                  ),
                ))
              ],
            ),
          )
        ],
      ),
    ),
  );
}
