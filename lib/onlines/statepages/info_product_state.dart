import 'package:get/get.dart';

class InfoProductState extends GetxController{
  var size = 0.obs;
  var amount = 1.obs;
  var rate = 1.0.obs;
  disAmount(){
    if(amount>1){
      amount.value = amount.value-1;
    }
  }
  addAmout(int amountproduct){
    if(amount<amountproduct){
      amount.value = amount.value+1;
    }
  }
}