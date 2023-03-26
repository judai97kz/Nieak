import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../view_pages/home_page.dart';
import '../view_pages/vertify_page.dart';

class LoginModelView {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> signIn(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => MyWidget(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return null;
    }
  }

  LogInPhoneAction(String phonenumber, BuildContext context) async {
    if(phonenumber.substring(0,1)=="0"){
      phonenumber = phonenumber.substring(1);
    }
    phonenumber ="+84"+phonenumber;
    print(phonenumber);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phonenumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (builder) => MyWidget()));
      },
      verificationFailed: (FirebaseAuthException e) {
        print("Loi");
      },
      codeSent: (verificationId, forceResendingToken) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) =>
                VerificationPage(verificationId: verificationId),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      timeout: Duration(seconds: 60),
    );
  }
}
