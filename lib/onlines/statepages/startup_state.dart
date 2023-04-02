import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nieak/onlines/modelviews/login_modelview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartUpState extends GetxController {
  var checkstartup = false.obs;
  final loginaction = Get.put(LoginModelView());
  Future<void> CheckAuto(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final String? uid = prefs.getString('uid');
    if (uid != null) {
      // ignore: use_build_context_synchronously
      loginaction.LoginWithSharedPreferences(uid, context);
      return;
    }else{
      checkstartup.value = true;
    }

  }
}
