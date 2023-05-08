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
                "Mã Hóa Đơn: ${product['idbill']}"),
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
                    product['content'][i]['sale']==0?Text(
                        "- ${product['content'][i]['nameproduct']} size ${product['content'][i]['size']} x ${product['content'][i]['amount']} (Đơn giá: ${myFormat.format(product['content'][i]['price'])}đ/đôi)"):Text(
                        "- ${product['content'][i]['nameproduct']} size ${product['content'][i]['size']} x ${product['content'][i]['amount']} (Giá khuyến mãi: ${myFormat.format(product['content'][i]['price'] * (100 - product['content'][i]['sale']) / 100)}đ/đôi)")
                  ],
                ),
              ),
            ),
          SizedBox(
            height: 20,
          ),
         Center(
            child: Container(
              width: MediaQuery.of(context).orientation==Orientation.portrait?MediaQuery.of(context).size.width/2:MediaQuery.of(context).size.height/2,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey)
              ),),
          ),
          Align(alignment: Alignment.centerRight, child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Tổng giá trị: ${myFormat.format(product['allprice'])}đ"),
          )),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
                "Tình trạng: ${product['acceptstate'] == true ? "Đã xác nhận" : "Chưa xác nhận"}"),
          ),
          Center(child: ElevatedButton(onPressed: (){billModel.generatePdf(product,context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Đã lưu vào thư mục /storage/emulated/0/Android/data/com.judai.nieak/files")));
            }, child: Text("In hóa đơn"))),
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
                          child: Text("Đã nhận được hàng"),
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
                                    "Bạn có chắc rằng là bạn muốn xóa đơn hàng !\n(Chú ý: bạn hãy chụp lại đơn hàng hoặc in hóa đơn trước khi hủy đơn hàng để làm chứng cứ khi liên hệ với nhân viên để được hoàn tiền!)"),
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
