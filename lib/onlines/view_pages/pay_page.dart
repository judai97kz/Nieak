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
      // firestore.collection('bill').doc(temp).update({
      //   'content': FieldValue.arrayUnion([cartTemp.list_temp[i]]),
      // });
      list.add(cartTemp.list_temp[i]);
    }
    BillModel bill = BillModel(
        idbill: '${userInfo.uidtemp.value}${date}',
        iduser: userInfo.uidtemp.value,
        datecreate: date,
        content: list,
        allprice: payState.allsum.value,
        acceptstate: false,
        receivestate: false);
    var temp = '${userInfo.uidtemp.value}${date}';
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('bill').doc(temp).set(bill.toJson());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    payState.sumprice();
    print(payState.allsum);
    for (int i = 0; i < cartTemp.list_temp.length; i++) {
      var tempprice = 0;
      if(cartTemp.list_temp[i]['sale']==0){
        tempprice = cartTemp.list_temp[i]['price'];
      }else{
        tempprice = (cartTemp.list_temp[i]['price']*(100-cartTemp.list_temp[i]['sale'])/100).toInt();
      }
      Map<String, dynamic> item = {
        "name": cartTemp.list_temp[i]['sale']==0?"${cartTemp.list_temp[i]['nameproduct']}":"${cartTemp.list_temp[i]['nameproduct']}(Khuyến Mãi)",
        "quantity": cartTemp.list_temp[i]['amount'],
        "price": tempprice,
        "currency": "USD"
      };
      listProduct.add(item);
    }
    print(listProduct);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => payState.checkPay.value == true
        ? PaySuccessPage()
        : Scaffold(
            appBar: AppBar(
              title: Text("Thông Tin Dơn Hàng"),
            ),
            body: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 30,
                        child: Center(child: Text("Chi tiết đơn hàng"))),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
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
                          "Tổng Tiền: ${myFormat.format(payState.allsum.value)}",
                        ),
                      )),
                    ),
                    Container(
                        child: Center(child: Text("Thông tin người nhận"))),
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
                                print("onSuccess: $params");
                                makeABill();
                                payState.checkPay.value = await true;
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