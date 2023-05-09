import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nieak/onlines/mini_widget/pay_widget.dart';
import 'package:nieak/onlines/models/bill_model.dart';
import 'package:nieak/onlines/modelviews/user_state.dart';
import 'package:nieak/onlines/statepages/cart_state.dart';
import 'package:nieak/onlines/statepages/pay_state.dart';
import 'package:nieak/onlines/view_pages/pay_success_page.dart';

class PayPage extends StatefulWidget {
  const PayPage({Key? key}) : super(key: key);

  @override
  State<PayPage> createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  final cartTemp = Get.put(CartState());
  final payState = Get.put(PayState());
  final userInfo = Get.put(UserState());
  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
  final listProduct = [];

  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String address = "";

  Future<void> makeABill() async {
    var date = DateTime.now().toString();
    var list = [];
    for (int i = 0; i < cartTemp.list_temp.length; i++) {
      list.add(cartTemp.list_temp[i]);
    }
    BillModel bill = BillModel(
        idbill: '${userInfo.uidtemp.value}${date}',
        cancel: false,
        iduser: userInfo.user.value!.id,
        username: userInfo.user.value!.name,
        datecreate: date,
        content: list,
        allprice: payState.allsum.value,
        acceptstate: false,
        receivestate: false,
        userphone: userInfo.user.value!.phone,addressreceive: userInfo.user.value!.address);
    var temp = '${userInfo.uidtemp.value}${date}';
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('bill').doc(temp).set(bill.toJson());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    payState.sumprice();

    for (int i = 0; i < cartTemp.list_temp.length; i++) {
      var tempprice = 0;
      if (cartTemp.list_temp[i]['sale'] == 0) {
        tempprice = cartTemp.list_temp[i]['price'];
      } else {
        tempprice = (cartTemp.list_temp[i]['price'] *
                (100 - cartTemp.list_temp[i]['sale']) /
                100)
            .toInt();
      }
      Map<String, dynamic> item = {
        "name": cartTemp.list_temp[i]['sale'] == 0
            ? "${cartTemp.list_temp[i]['nameproduct']}"
            : "${cartTemp.list_temp[i]['nameproduct']}(Khuyến Mãi)",
        "quantity": cartTemp.list_temp[i]['amount'],
        "price": tempprice,
        "currency": "USD"
      };
      listProduct.add(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => payState.checkPay.value == true
        ? PaySuccessPage()
        : Scaffold(
            appBar: AppBar(
              title: Text("Thông Tin Đơn Hàng"),
            ),
            body: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 30,
                          child: Center(
                            child: Text(
                              "Chi Tiết Đơn Hàng",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        child: Obx(() => ListView.builder(
                              shrinkWrap: true,
                              itemCount: cartTemp.list_temp.length,
                              itemBuilder: (context, index) => PayWidget(
                                  context, cartTemp.list_temp[index], index),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Tổng Tiền: ${myFormat.format(payState.allsum.value)}đ",
                          style: TextStyle(fontSize: 15),
                        ),
                      )),
                    ),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          child: Center(
                              child: Text(
                        "Thông Tin Người Nhận",
                        style: TextStyle(fontSize: 20),
                      ))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Khách hàng: ${userInfo.user.value!.name}"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Điện thoại: ${userInfo.user.value!.phone}"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Địa chỉ: ${userInfo.user.value!.address}"),
                    ),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          "Chú ý: bạn chỉ có thể hủy đơn hàng khi đơn hàng đó chưa được xác thực. Nếu bạn muốn hủy đơn hàng sau khi đơn hàng được xác thực, xin hãy liên hệ với nhận viên qua mục 'Liên Hệ' để được giải quyết!"),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => UsePaypal(
                              sandboxMode: true,
                              clientId:
                                  "AXAsN9H-30VbNuo-EYRLU2zCG_Csvsbxdi0wcaGKKvTh_sElizd07LGWHhSCcpixirDPZgS22LIp9LKg",
                              secretKey:
                                  "EFkfXhlOplaT3t3pncl4MNGPR7Atq-BoNAf-mOyvs1RSWWBnZ6z0rmw96MlrortcRVM1vxe0cyOZaWk3",
                              returnURL: "https://samplesite.com/return",
                              cancelURL: "https://samplesite.com/cancel",
                              transactions: [
                                {
                                  "amount": {
                                    "total": payState.allsum.value,
                                    "currency": "USD",
                                    "details": {
                                      "subtotal": payState.allsum.value,
                                      "shipping": '0',
                                      "shipping_discount": 0
                                    }
                                  },
                                  "description":
                                      "The payment transaction description.",
                                  // "payment_options": {
                                  //   "allowed_payment_method":
                                  //       "INSTANT_FUNDING_SOURCE"
                                  // },
                                  "item_list": {
                                    "items": listProduct,
                                    // shipping address is not required though
                                    "shipping_address": {
                                      "recipient_name": userInfo.uidtemp.value,
                                      "line1": userInfo.user.value!.address,
                                      "line2": "",
                                      "city": "Austin",
                                      "country_code": "VN",
                                      "postal_code": "73301",
                                      "phone": "+00000000",
                                      "state": "Texas"
                                    },
                                  }
                                }
                              ],
                              note:
                                  "Contact us for any questions on your order.",
                              onSuccess: (Map params) async {
                                makeABill();
                                payState.checkPay.value = await true;
                              },
                              onError: (error) {
                                print("onError: $error");
                              },
                              onCancel: (params) {
                                print('cancelled: $params');
                              }),
                        ),
                      );
                    },
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.red),
                      child: Center(child: Text("Xác nhận thanh toán")),
                    ),
                  ),
                )
              ],
            )));
  }
}
