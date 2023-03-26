import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nieak/onlines/statepages/signup_state.dart';
import '../models/user_model.dart';
import '../view_pages/vertify_email_page.dart';

class SignUpModelView extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final signupaction = Get.put(SignUpState());
  Future<void> registerWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Tạo tài khoản thành công
      User? user = userCredential.user;
      await user?.sendEmailVerification();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => VertifyEmailPage()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Mật khẩu quá yếu.');
      } else if (e.code == 'email-already-in-use') {
        print('Email đã được sử dụng.');
        signupaction.emailstate.value = "Email đã được sử dụng.";
      }
    } catch (e) {
      print(e);
    }
  }

  SignUpAction(String username, String password, String rppassword, String name,
      String phone, String address, BuildContext context) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('admin')
        .doc(username)
        .get();
    if (snapshot.exists) {
      AlertDialog alert = AlertDialog(
        title: Text("Thông Báo"),
        content: Text("Tên người dùng đã tồn tại"),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'))
        ],
      );
    } else {
      // UserModel newuser = UserModel(
      //     name: name,
      //     phone: phone,
      //     address: address,
      //     idcart: "Judai",
      //     wallet: 1233435435,
      //     role: 1);
      // firestore.collection("admin").doc(username).set(newuser.toJson());
      print("thêm thanh công");
    }
  }
}
