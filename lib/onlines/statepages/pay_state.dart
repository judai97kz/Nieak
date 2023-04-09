import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:get/get.dart';
import 'package:nieak/onlines/statepages/cart_state.dart';
import 'package:nieak/onlines/statepages/management_state.dart';
import 'package:nieak/onlines/view_pages/management_page.dart';

class PayState extends GetxController {
  var allsum = 0.obs;
  var checkPay = false.obs;
  sumprice() {
    final listtemp = Get.put(CartState());
    int sum = 0;
    for (int i = 0; i < listtemp.list_temp.length; i++) {
      sum = sum + int.parse(listtemp.list_temp[i]["price"].toString()) *
          int.parse(listtemp.list_temp[i]["amount"].toString());
    }
    allsum.value = sum;
    sum = 0;
  }

  backFuntion(BuildContext context){
    final payTemp = Get.put(CartState());
    final managementState = Get.put(ManagementState());
    checkPay.value = false;
    print(payTemp.list_check.length);
    payTemp.createList(payTemp.list_check.length);
    payTemp.checkTrue();
    managementState.currentindex.value=0;
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (builder) => ManagementPage()));
  }
}