import 'package:get/get.dart';

class CartState extends GetxController{
  var list_check = [].obs;
  var list_temp = [].obs;
  var buttonState = false.obs;
  createList(int n){
    List<bool> boolList = List.generate(n, (index) => false);
    list_check.value = boolList;
  }
  checkTrue(){
    for(int i=0;i<list_check.length;i++){
      if(list_check[i]==true){
        buttonState.value=true;
        return;
      }
    }
    buttonState.value=false;
  }
}