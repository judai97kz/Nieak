import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nieak/onlines/statepages/login_state.dart';
import 'package:nieak/onlines/view_pages/forget_password_page.dart';
import 'package:nieak/onlines/view_pages/signup_page.dart';
import '../modelviews/login_modelview.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginaction = LoginModelView();
  final loginstate = Get.put(LoginState());
  final email = TextEditingController();
  final password = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/public/bg1.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white, width: 5)),
                    child: Image.asset(
                      "assets/public/logo.png",
                      height: 270,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Obx(() => loginstate.mailstate == 0
                    ? const SizedBox(
                        height: 0,
                      )
                    : Obx(
                        () => Container(
                          height: 300,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextField(
                                  decoration: InputDecoration(
                                      errorText:
                                          loginstate.emailtext.value == ""
                                              ? null
                                              : loginstate.emailtext.value,
                                      filled: true,
                                      fillColor: Colors.white70,
                                      labelText: "Email"),
                                  style: const TextStyle(color: Colors.black),
                                  textInputAction: TextInputAction.next,
                                  controller: email,
                                ),
                              ),
                              Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        TextField(
                                          decoration: InputDecoration(
                                              errorText: loginstate
                                                          .passtext.value ==
                                                      ""
                                                  ? null
                                                  : loginstate.passtext.value,
                                              filled: true,
                                              fillColor: Colors.white70,
                                              labelText: "Mật khẩu"),
                                          obscureText:
                                              loginstate.hidepass.value == false
                                                  ? true
                                                  : false,
                                          style: const TextStyle(
                                              color: Colors.black),
                                          onSubmitted: (passwordcontroller) {
                                            loginstate.CheckNullText(email.text,
                                                password.text, context);
                                          },
                                          textInputAction: TextInputAction.done,
                                          controller: password,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: GestureDetector(
                                              onTap: () {
                                                if (loginstate.hidepass ==
                                                    false) {
                                                  loginstate.hidepass.value =
                                                      true;
                                                } else {
                                                  loginstate.hidepass.value =
                                                      false;
                                                }
                                              },
                                              child: loginstate
                                                          .hidepass.value ==
                                                      false
                                                  ? Icon(
                                                      Icons.remove_red_eye,
                                                    )
                                                  : Icon(Icons
                                                      .remove_red_eye_outlined),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                  onTap: () {
                                    loginstate.CheckNullText(
                                        email.text, password.text, context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 40,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.orangeAccent
                                                  .withOpacity(0.5),
                                              offset: const Offset(0.0, 1.0),
                                              blurRadius: 2.0,
                                              spreadRadius: 0.0,
                                            ),
                                          ],
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: const Center(
                                          child: Text(
                                        "Đăng Nhập",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color:
                                                Color.fromARGB(242, 10, 14, 0)),
                                      )),
                                    ),
                                  )),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => SignupPage()));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Chưa có tài khoản?",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    GestureDetector(
                                      child: const Text(
                                        "Đăng ký ngay!",
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Colors.blue),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ForgetPasswordPage()));
                                  },
                                  child: Text(
                                    "Quên mật khẩu?",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                                child: Center(
                                  child: Text(
                                    "Hoặc",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                Obx(() => loginstate.phonestate == 0
                    ? SizedBox(
                        height: 0,
                      )
                    : Container(
                        height: 170,
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white60,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Text("+84"),
                                      width: 40,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        decoration: InputDecoration(
                                            hintText: "Nhập số điện thoại"),
                                        controller: _phoneController,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                loginaction.LogInPhoneAction(
                                    _phoneController.text, context);
                              },
                              child: Text("Đăng nhập bằng mã SMS")),
                          const SizedBox(
                            height: 30,
                            child: Center(
                              child: Text(
                                "Hoặc",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ]),
                      )),
                Obx(
                  () => loginstate.mailbutton == 1
                      ? const SizedBox(
                          height: 0,
                        )
                      : Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            splashColor: Colors.red,
                            highlightColor: Colors.white,
                            onTap: () {
                              loginstate.mailstate.value = 1;
                              loginstate.mailbutton.value = 1;
                              loginstate.phonestate.value = 0;
                              loginstate.phonebutton.value = 0;
                            },
                            child: Ink(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.black)),
                                width: double.infinity,
                                height: 50,
                                child: Stack(
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(60, 8, 8, 8),
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Icon(Icons.email)),
                                    ),
                                    Center(child: Text("Đăng nhập bằng Mail"))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
                Obx(
                  () => loginstate.phonebutton == 1
                      ? const SizedBox(
                          height: 0,
                        )
                      : GestureDetector(
                          onTap: () {
                            loginstate.phonestate.value = 1;
                            loginstate.phonebutton.value = 1;
                            loginstate.mailbutton.value = 0;
                            loginstate.mailstate.value = 0;
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.black)),
                              width: double.infinity,
                              child: Stack(
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(60, 8, 8, 8),
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Icon(Icons.phone)),
                                  ),
                                  Center(
                                      child: Text("Đăng nhập bằng điện thoại"))
                                ],
                              ),
                            ),
                          ),
                        ),
                ),
                GestureDetector(
                  onTap: () {
                    loginaction.signInWithGoogle(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black)),
                      width: double.infinity,
                      child: Stack(
                        children: const [
                          Padding(
                            padding: EdgeInsets.fromLTRB(60, 8, 8, 8),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "G",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                )),
                          ),
                          Center(child: Text("Đăng nhập bằng Google"))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//
// Padding(
// padding: const EdgeInsets.all(40.0),
// child: Container(
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(100),
// border: Border.all(color: Colors.black, width: 10)),
// child: Image.asset("assets/nieaklogo.png")),
// ),
//
