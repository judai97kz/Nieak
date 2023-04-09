import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:nieak/onlines/modelviews/bill_modelview.dart';
import 'package:nieak/onlines/modelviews/user_state.dart';

Widget BillWidget(BuildContext context, Map<String, dynamic> product) {
  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
  int contentLength = product['content'].length;
  final iduser = Get.put(UserState());
  final billModel = Get.put(BillModelView());
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Text(
                "Mã Hóa Đơn: ${product['iduser']}-${product['datecreate']}"),
          ),
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          ),
          Text("Thời gian mua: ${product['datecreate']}"),
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 20,
              child: Text("Sản phẩm đã mua:"),
            ),
          ),
          for (int i = 0; i < contentLength; i++)
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                child: Column(
                  children: [
                    Text(
                        "- ${product['content'][i]['nameproduct']} size ${product['content'][i]['size']} x ${product['content'][i]['amount']} (đơn giá: ${myFormat.format(product['content'][i]['price'])}đ/đôi)")
                  ],
                ),
              ),
            ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
                "Tình trạng: ${product['acceptstate'] == true ? "Đã xác nhận" : "Chưa xác nhận"}"),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Stack(
              children: [
                product['acceptstate'] == true
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton(
                          onPressed: product['receivestate'] == true
                              ? null
                              : () {
                                  final billState = Get.put(BillModelView());
                                  billState.updateReveiceState(
                                      product['idbill'], iduser.uidtemp.value);
                                },
                          child: Text("Đã nhận đươc hàng"),
                        ),
                      )
                    : SizedBox(
                        height: 0,
                      ),
                SizedBox(
                  height: 10,
                ),
                product['acceptstate'] == true
                    ? SizedBox(
                        height: 0,
                      )
                    : Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                            onPressed: () {
                              AlertDialog dialog = AlertDialog(
                                title: Text("Thông Báo"),
                                content: Text(
                                    "Bạn có chắc rằng là bạn muốn xóa đơn hàng !"),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () async {
                                        billModel.deleteBill(product['idbill'],
                                            iduser.uidtemp.value);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Xác nhận")),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Hủy"))
                                ],
                              );
                              showDialog(
                                  context: context,
                                  builder: (context) => dialog);
                            },
                            child: Text("Hủy đơn hàng")),
                      )
              ],
            ),
          )
        ],
      ),
    ),
  );
}
