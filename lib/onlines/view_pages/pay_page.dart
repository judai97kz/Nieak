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

  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String address = "";

  void makeABill() {
    var date = DateTime.now().toString();

    BillModel bill = BillModel(
        idbill: '${userInfo.uidtemp.value}${date}',
        iduser: userInfo.uidtemp.value,
        datecreate: date,
        content: [],
        allprice: payState.allsum.value,
        acceptstate: false,
        receivestate: false);
    var temp = '${userInfo.uidtemp.value}${date}';
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('bill').doc(temp).set(bill.toJson());
    for (int i = 0; i < cartTemp.list_temp.length; i++) {
      firestore.collection('bill').doc(temp).update({
        'content': FieldValue.arrayUnion([cartTemp.list_temp[i]]),
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    payState.sumprice();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => payState.checkPay.value == true
        ? PaySuccessPage()
        : Scaffold(
            appBar: AppBar(),
            body: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Chi tiết đơn hàng"),
                    Container(
                      child: Obx(() => ListView.builder(
                            shrinkWrap: true,
                            itemCount: cartTemp.list_temp.length,
                            itemBuilder: (context, index) => PayWidget(
                                context, cartTemp.list_temp[index], index),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Tổng Tiền: ${myFormat.format(payState.allsum.value)}",
                        ),
                      )),
                    ),
                    Text("Thông tin người nhận"),
                    Text("Khách hàng: ${userInfo.user.value!.name}"),
                    Text("Điện thoại: ${userInfo.user.value!.phone}"),
                    Text("Địa chỉ: ${userInfo.user.value!.address}")
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
                              transactions: const [
                                {
                                  "amount": {
                                    "total": '100',
                                    "currency": "USD",
                                    "details": {
                                      "subtotal": '0',
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
                                    "items": [
                                      {
                                        "name": "A demo product",
                                        "quantity": 1,
                                        "price": '0',
                                        "currency": "USD"
                                      }
                                    ],

                                    // shipping address is not required though
                                    "shipping_address": {
                                      "recipient_name": "Jane Foster",
                                      "line1": "Travis County",
                                      "line2": "",
                                      "city": "Austin",
                                      "country_code": "US",
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
                                print("onSuccess: $params");
                                makeABill();
                                payState.checkPay.value = true;
                              },
                              onError: (error) {
                                print("onError: $error");
                              },
                              onCancel: (params) {
                                print('cancelled: $params');
                                print("ĐÃ HỦy");
                              }),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      child: Text("Xác nhận thanh toán"),
                    ),
                  ),
                )
              ],
            )));
  }
}
