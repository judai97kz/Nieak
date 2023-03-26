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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userState.checkEmailVerified();
  }
  @override
  Widget build(BuildContext context) {
    User user = _auth.currentUser!;
    print(userState.isEmailVerified.value);
    print(user);
    return Scaffold(
        body: Container(
      child: Obx(
        () => userState.isEmailVerified.value
            ? Text('Email đã được xác nhận')
            : Container(
                child: Column(
                  children: [
                    ElevatedButton(
                        onPressed: () => userState.checkEmailVerified(),
                        child: Text('Xác nhận email'))
                  ],
                ),
              ),
      ),
    ));
  }
}
