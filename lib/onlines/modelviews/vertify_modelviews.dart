import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nieak/onlines/view_pages/create_info_page.dart';

import '../view_pages/home_page.dart';

class VertifyModelView extends GetxController{
  checkNewUser(String uid,BuildContext context) async {
    final CollectionReference myCollectionRef =
    FirebaseFirestore.instance.collection('user');
    final DocumentReference myDocRef = myCollectionRef.doc(uid);
    final docSnapshot = await myDocRef.get();
    if (docSnapshot.exists) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => MyWidget(),
        ),
      );
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (builder)=>CreateInfoPage()));
    }
  }
}