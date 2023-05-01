import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nieak/onlines/modelviews/bill_modelview.dart';
import 'package:nieak/onlines/modelviews/home_modelview.dart';

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
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Text("Khách hàng: ${product['username']}"),
          ),
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          ),
          Text("Thời gian mua: ${product['datecreate']}"),
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
              height: 20,
              child: Text("Sản phẩm đã mua:"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              child: Column(
                children: [
                  for (int i = 0; i < contentLength; i++)
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: product['content'][i]['sale'] == 0
                          ? Text(
                              "- ${product['content'][i]['nameproduct']} size ${product['content'][i]['size']} x ${product['content'][i]['amount']} (Đơn giá: ${myFormat.format(product['content'][i]['price'])}đ/đôi)")
                          : Text(
                              "- ${product['content'][i]['nameproduct']} size ${product['content'][i]['size']} x ${product['content'][i]['amount']} (Giá khuyến mãi: ${myFormat.format(product['content'][i]['price'] * (100 - product['content'][i]['sale']) / 100)}đ/đôi)"),
                    )
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.width / 2
                  : MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            ),
          ),
          Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "Tổng giá trị: ${myFormat.format(product['allprice'])}đ"),
              )),
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
                        final updateAmount = Get.put(HomeModelView());
                        bill.updateAcceptState(product['idbill']);
                        for (int i = 0; i < contentLength; i++){
                          updateAmount.updateAmount(product['content'][i]['idshoes'],product['content'][i]['amount']);
                        }

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
