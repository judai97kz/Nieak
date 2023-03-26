import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nieak/onlines/modelviews/signup_modelview.dart';
import 'package:nieak/onlines/view_pages/vertify_email_page.dart';

class SignUpState extends GetxController{
  var emailstate = "".obs;
  var passstate ="".obs;
  var repeatstate ="".obs;

  CheckNull(String email,String password,String repeat,BuildContext context){
    if(email==""){
      emailstate.value="Không được để trống";
      return;
    }
    emailstate.value="";
    if(email.contains("@")==false || email.contains(".com")==false){
      emailstate.value="Định dạng email chưa chính xác";
      return;
    }
    if(password=="" || password.length<8){
      passstate.value = "Độ dài mật khẩu phải lớn hơn 8";
      return;
    }
    passstate.value ="";
    if(repeat=="" || repeat.length<8){
      repeatstate.value = "Độ dài mật khẩu nhập lại phải lớn hơn 8";
      return;
    }
    if(repeat!=password){
      repeatstate.value = "Mật khẩu không đúng";
      return;
    }
    repeatstate.value="";
    final signupaction = Get.put(SignUpModelView());
    signupaction.registerWithEmailAndPassword(email, password, context);

  }
}