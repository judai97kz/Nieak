import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/_http/_html/_file_decoder_html.dart';

import '../modelviews/user_state.dart';

class UserInfoState extends GetxController {
  var selectedFile = Rx<PlatformFile?>(null);

  uploadFile() async {
    final userstate = Get.put(UserState());
    UploadTask? uploadTask;
    final path = 'User/${userstate.user.value!.id.trim()}/Avatar';
    final file = File(selectedFile.value!.path!.trim());
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);
    final snapshot = await uploadTask!.whenComplete(() => null);
    final urlDL = await snapshot.ref.getDownloadURL();
    FirebaseFirestore.instance.collection('user').doc(userstate.user.value!.id.trim()).update({"imageAvatar":urlDL});
    selectedFile.value=null;
  }
}