import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nieak/onlines/modelviews/login_modelview.dart';

class LoginState extends GetxController {
  var mailstate = 0.obs;
  var phonestate = 0.obs;
  var mailbutton = 0.obs;
  var phonebutton = 0.obs;
  var emailtext = "".obs;
  var passtext ="".obs;
  var phonetext = "".obs;
  var hidepass = false.obs;
  CheckNullText(String email, String password,BuildContext context){
    if(email==""){
      emailtext.value="Không được để trống";
      return;
    }
    emailtext.value = "";
    if(email.contains("@")==false || email.contains(".com")==false){
      emailtext.value="Định dạng email chưa chính xác";
      print(emailtext);
      return;
    }
    emailtext.value = "";
    if(password=="" || password.length<8){
      passtext.value = "Độ dài mật khẩu phải lớn hơn 8";
      return;
    }
    passtext.value ="";
    final loginaction = Get.put(LoginModelView());
    loginaction.signIn(
        email, password, context);
  }
}
