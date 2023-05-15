import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nieak/onlines/models/user_model.dart';
import 'package:nieak/onlines/modelviews/login_modelview.dart';

class UserState extends GetxController {
  final isEmailVerified = false.obs;
  final userinfo = Rxn<UserCredential>();
  final user = Rxn<UserModel>(null);
  final uidtemp = "".obs;

  checkEmailVerified(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    final loginuser = LoginModelView();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    await user?.reload();
    print(user?.emailVerified);
    if (user?.emailVerified != false) {
      loginuser.CheckValueOfUser(user!.uid, context);
      Navigator.pop(context);
      isEmailVerified.value = true;
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email chưa được xác minh!")));
      isEmailVerified.value = false;
    }
  }

  InfoUser(String idUser) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('user').doc(idUser).get();
    UserModel theUser = UserModel.fromJson(snapshot.data()!);
    user.value = theUser;
  }
}
