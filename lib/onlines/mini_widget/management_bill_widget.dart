import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nieak/onlines/modelviews/bill_modelview.dart';

Widget ManagementBillWidget(
    BuildContext context, Map<String, dynamic> product) {
  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
  int contentLength = product['content'].length;
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Text("Mã Hóa Đơn: ${product['idbill']}"),
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
                "Tình trạng: ${product['receivestate'] == true ? "Đã nhận hàng" : "Chưa nhận hàng"}"),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: product['acceptstate'] == true
                    ? null
                    : () {
                        final bill = Get.put(BillModelView());
                        bill.updateAcceptState(product['idbill']);
                      },
                child: Text("Xác thực đơn hàng"),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    ),
  );
}
