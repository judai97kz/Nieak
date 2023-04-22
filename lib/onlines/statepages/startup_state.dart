import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nieak/onlines/modelviews/login_modelview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartUpState extends GetxController {
  var checkstartup = false.obs;
  var check_connect = false.obs;
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
  checkConnect(BuildContext context) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      check_connect.value=true;
      CheckAuto(context);
    } else {
      check_connect.value=false;
    }
  }
}
