import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nieak/onlines/modelviews/user_state.dart';
import 'package:nieak/onlines/view_pages/create_info_page.dart';
import 'package:nieak/onlines/view_pages/management_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VertifyModelView extends GetxController {
  checkNewUser(String uid, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final CollectionReference myCollectionRef =
        FirebaseFirestore.instance.collection('user');
    final DocumentReference myDocRef = myCollectionRef.doc(uid);
    final docSnapshot = await myDocRef.get();
    await prefs.setString('uid', uid);
    if (docSnapshot.exists) {
      final roleuser = Get.put(UserState());
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', uid);
      await roleuser.InfoUser(uid);
      if (docSnapshot['disable'] == true) {
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ManagementPage()));
      }
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => CreateInfoPage()));
    }
  }
}
