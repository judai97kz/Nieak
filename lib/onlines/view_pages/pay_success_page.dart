import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nieak/onlines/statepages/pay_state.dart';

class PaySuccessPage extends StatefulWidget {
  const PaySuccessPage({Key? key}) : super(key: key);

  @override
  State<PaySuccessPage> createState() => _PaySuccessPageState();
}

class _PaySuccessPageState extends State<PaySuccessPage> {
  final payState = Get.put(PayState());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          payState.backFuntion(context);
          return false;
        },
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/public/order_success.png",height: 80,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "Thanh toán thành công, đơn hàng của bạn sẽ sớm được xác nhận!",style: TextStyle(),textAlign: TextAlign.center,),
              ),
              ElevatedButton(
                  onPressed: () {
                    payState.backFuntion(context);
                  },
                  child: Text("Về Trang Chủ"))
            ],
          ),
        ),
      ),
    );
  }
}
