import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nieak/onlines/models/user_model.dart';
import 'package:nieak/onlines/modelviews/user_state.dart';
import 'package:nieak/onlines/view_pages/management_page.dart';

class CreateInfoState extends GetxController {
  var dateTime = "".obs;
  var fullname = "".obs;
  var gmailtext = "".obs;
  var phonetext = "".obs;
  var addresstext = "".obs;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1970, 1),
        lastDate: DateTime(2101));
    if (picked != null)
      dateTime.value = DateFormat('dd/MM/yyyy').format(picked);
  }

  Future<String> uploadFile(PlatformFile? pickedFile) async {
    final userstate = Get.put(UserState());
    UploadTask? uploadTask;
    final path = 'User/${userstate.userinfo.value?.user!.uid}/Avatar';
    final file = File(pickedFile!.path.toString());
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);
    final snapshot = await uploadTask!.whenComplete(() => null);
    final urlDL = await snapshot.ref.getDownloadURL();
    return urlDL;
  }

  _addMapToArray(String documentId, String fieldName,
      Map<String, dynamic> mapToAdd) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final DocumentReference documentReference =
        _firestore.collection('user').doc(documentId);
    await documentReference.update({
      fieldName: FieldValue.arrayUnion([mapToAdd]),
    });
  }

  CheckNull(String name, String date, String email, String phone,
      String address, PlatformFile? pickedFile, BuildContext context) async {
    print(pickedFile!.path);
    final userstate = Get.put(UserState());
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    print(userstate.userinfo);
    if (name == "") {
      fullname.value = "Không được bỏ trống!";
      return;
    }
    fullname.value = "";
    if (userstate.userinfo.value!.user!.email == null && email == "") {
      gmailtext.value = "Không được bỏ trống!";
      return;
    }
    gmailtext.value = "";
    print(userstate.userinfo.value!.user!.phoneNumber);
    if (userstate.userinfo.value!.user!.phoneNumber == null && phone == "") {
      phonetext.value = "Không được bỏ trống!";
      return;
    }
    phonetext.value = "";
    if (address == "") {
      addresstext.value = "Không được bỏ trống!";
      return;
    }
    addresstext.value = "";

    String imgUrl = await uploadFile(pickedFile);
    UserModel newuser = UserModel(
      id:userstate.userinfo.value!.user!.uid,
        name: name,
        phone: phone,
        address: address,
        birthday: date,
        cart: [],
        imageAvatar: imgUrl,
        disable: false,
        role: 0);
    print(userstate.uidtemp);
    firestore
        .collection('user')
        .doc(userstate.userinfo.value!.user!.uid)
        .set(newuser.toJson());
    // await _addMapToArray(userstate.uidtemp.value, 'cart');
    try {
      final CollectionReference myCollectionRef =
          FirebaseFirestore.instance.collection('user');
      final DocumentReference myDocRef =
          myCollectionRef.doc(userstate.userinfo.value!.user!.uid);
      final docSnapshot = await myDocRef.get();
      if (docSnapshot.exists) {
        await userstate.InfoUser(userstate.userinfo.value!.user!.uid);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => ManagementPage(),
          ),
        );
      } else {
        firestore
            .collection("user")
            .doc(userstate.userinfo.value!.user!.uid)
            .set(newuser.toJson());
      }
    } catch (e) {
      print("lỗi");
    }
  }
}
