import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nieak/onlines/statepages/signup_state.dart';

import '../modelviews/signup_modelview.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _usernamecontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final _repeatcontroller = TextEditingController();
  final signupaction = Get.put(SignUpModelView());
  final signupstate = Get.put(SignUpState());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đăng Ký"),
        // ignore: prefer_const_constructors
        leading: BackButton(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/public/signup_logo.png",
                        height: 100,
                      )),
                  const Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        "Đăng Ký Tài Khoản",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      )),
                ],
              ),
            ),
            Obx(
              () => Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "Tên Đăng Nhập",
                    errorText: signupstate.emailstate == ""
                        ? null
                        : signupstate.emailstate.value,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(width: 1, color: Colors.black)),
                    // ignore: unrelated_type_equality_checks
                  ),
                  controller: _usernamecontroller,
                ),
              ),
            ),
            Obx(
              () => Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      obscureText:
                          signupstate.hidepw.value == true ? true : false,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: "Mật Khẩu",
                        errorText: signupstate.passstate == ""
                            ? null
                            : signupstate.passstate.value,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                width: 1, color: Colors.black)),
                        // ignore: unrelated_type_equality_checks
                      ),
                      controller: _passwordcontroller,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 25, 20, 0),
                      child: GestureDetector(
                        onTap: () {
                          if (signupstate.hidepw.value == false) {
                            signupstate.hidepw.value = true;
                          } else {
                            signupstate.hidepw.value = false;
                          }
                        },
                        child: signupstate.hidepw.value == true
                            ? Icon(Icons.remove_red_eye_outlined)
                            : Icon(Icons.remove_red_eye),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Obx(
              () => Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      obscureText:
                          signupstate.hiderp.value == true ? true : false,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: "Mật Khẩu Lặp Lại",
                        errorText: signupstate.repeatstate == ""
                            ? null
                            : signupstate.repeatstate.value,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                width: 1, color: Colors.black)),
                      ),
                      controller: _repeatcontroller,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 25, 20, 0),
                      child: GestureDetector(
                        onTap: () {
                          if (signupstate.hiderp.value == false) {
                            signupstate.hiderp.value = true;
                          } else {
                            signupstate.hiderp.value = false;
                          }
                        },
                        child: signupstate.hiderp.value == true
                            ? Icon(Icons.remove_red_eye_outlined)
                            : Icon(Icons.remove_red_eye),
                      ),
                    ),
                  )
                ],
              ),
            ),

            ElevatedButton(
                onPressed: () async {
                  signupstate.CheckNull(
                      _usernamecontroller.text,
                      _passwordcontroller.text,
                      _repeatcontroller.text,
                      context);
                },
                child: const Text("ĐĂNG KÝ")),
            // ignore: prefer_const_constructors
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
