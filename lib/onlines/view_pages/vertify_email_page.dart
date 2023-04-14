import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:nieak/onlines/modelviews/user_state.dart';

class VertifyEmailPage extends StatefulWidget {
  const VertifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VertifyEmailPage> createState() => _VertifyEmailPageState();
}

class _VertifyEmailPageState extends State<VertifyEmailPage> {
  final userState = Get.put(UserState());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userState.checkEmailVerified(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  Obx(
        () => userState.isEmailVerified.value
            ? Container(
          child: Center(
            child: Text("Xác nhận thành công!"),
          ),
        )
            : Container(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 100,
                            child: Image.asset("assets/public/send.png")),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: const Text("Chúng tôi đã gửi một link tới Email của bạn, hãy xác nhận trong Email để tiếp tục bước tiếp theo!",textAlign: TextAlign.center,),
                      ),
                      ElevatedButton(
                          onPressed: () => userState.checkEmailVerified(context),
                          child: Text('Kiểm tra xác minh'))
                    ],
                  ),

              ),
            ),
    ));
  }
}
