import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nieak/onlines/modelviews/user_state.dart';
import 'package:nieak/onlines/view_pages/create_info_page.dart';
import 'package:nieak/onlines/view_pages/disable_account_page.dart';
import 'package:nieak/onlines/view_pages/management_page.dart';
import 'package:nieak/onlines/view_pages/vertify_email_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../view_pages/vertify_page.dart';

class LoginModelView {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final roleuser = Get.put(UserState());

  signIn(String email, String password, BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = FirebaseAuth.instance.currentUser;
      roleuser.userinfo.value = userCredential;
      try {
        if (user!.emailVerified != false) {
          CheckValueOfUser(userCredential.user!.uid, context);
        } else {
          User? tempuser = userCredential.user;
          await tempuser?.sendEmailVerification();
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => VertifyEmailPage()));
        }
      } catch (e) {
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email không tồn tại!')));
        Navigator.pop(context);
      } else if (e.code == 'wrong-password') {
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Sai mật khẩu')));
      }
      return;
    }
  }

  LogInPhoneAction(String phonenumber, BuildContext context) async {
    if (phonenumber.substring(0, 1) == "0") {
      phonenumber = phonenumber.substring(1);
    }
    phonenumber = "+84" + phonenumber;
    try {
      FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phonenumber,
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) {
        },
        codeSent: (verificationId, forceResendingToken) {
          print(verificationId);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  VerificationPage(verificationId: verificationId),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: Duration(seconds: 100),
      );
    } catch (e) {
      print(e);
    }
  }

  LoginWithSharedPreferences(String uid, BuildContext context) async {
    final CollectionReference myCollectionRef =
        FirebaseFirestore.instance.collection('user');
    final DocumentReference myDocRef = myCollectionRef.doc(uid);
    final docSnapshot = await myDocRef.get();
    try {
      if (docSnapshot.exists) {
        if (docSnapshot['disable'] == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => DisableAccountPage(),
            ),
          );
        } else {
          roleuser.uidtemp.value = uid;
          await roleuser.InfoUser(uid);
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => ManagementPage(),
            ),
          );
        }
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (builder) => CreateInfoPage()));
      }
    } catch (e) {
      print("error code");
    }
  }

  CheckValueOfUser(String uid, BuildContext context) async {
    try {
      final CollectionReference myCollectionRef =
          FirebaseFirestore.instance.collection('user');
      final DocumentReference myDocRef = myCollectionRef.doc(uid);
      final docSnapshot = await myDocRef.get();
      if (docSnapshot.exists) {
        roleuser.uidtemp.value = uid;
        await roleuser.InfoUser(uid);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('uid', uid);
        if (docSnapshot['disable'] == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => DisableAccountPage(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => ManagementPage(),
            ),
          );
        }
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (builder) => CreateInfoPage()));
      }
    } catch (e) {}
  }

  signInWithGoogle(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Đăng nhập bị hủy bởi người dùng');
    }
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = await FirebaseAuth.instance.currentUser;
      roleuser.userinfo.value = userCredential;
      try {
        if (user!.emailVerified != false) {
          CheckValueOfUser(userCredential.user!.uid, context);
        } else {
          User? tempuser = userCredential.user;
          await tempuser?.sendEmailVerification();
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => VertifyEmailPage()));
        }
      } catch (e) {}
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email không tồn tại!')));
        Navigator.pop(context);
      } else if (e.code == 'wrong-password') {
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Sai mật khẩu')));
      }
      return;
    }
  }
}
