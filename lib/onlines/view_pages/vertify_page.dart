import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nieak/onlines/modelviews/user_state.dart';
import 'package:nieak/onlines/modelviews/vertify_modelviews.dart';

class VerificationPage extends StatefulWidget {
  final String verificationId;

  VerificationPage({required this.verificationId});

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _smsCodeController = TextEditingController();
  final userstate = Get.put(UserState());
  final checkvertifystate = Get.put(VertifyModelView());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Xác Minh Số Điện Thoại'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _smsCodeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Verification code',
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                child: Text('Xác Minh'),
                onPressed: () async {
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: _smsCodeController.text,
                  );
                  print("credential: ${credential}");
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance
                        .signInWithCredential(credential);
                    if (userCredential.user != null) {
                      userstate.userinfo.value = userCredential;
                      await checkvertifystate.checkNewUser(
                          userCredential.user!.uid, context);
                    } else {
                      print("Thât bại");
                    }
                  } catch (e) {
                    print("error code");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
