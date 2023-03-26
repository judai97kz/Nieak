import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginState extends GetxController {
  var mailstate = 0.obs;
  var phonestate = 0.obs;
  var mailbutton = 0.obs;
  var phonebutton = 0.obs;
  var emailtext = "".obs;
  var passtext ="".obs;
  var phonetext = "".obs;
  CheckNullText(String email, String password,BuildContext context){
    if(email==""){
      emailtext.value="Không được để trống";
      return;
    }
    if(email.contains("@")==false || email.contains(".com")==false){
      emailtext.value="Định dạng email chưa chính xác";
      return;
    }
    emailtext.value = "";
    if(password=="" || password.length<8){
      passtext.value = "Độ dài mật khẩu phải lớn hơn 8";
      return;
    }
    passtext.value ="";
  }
}
