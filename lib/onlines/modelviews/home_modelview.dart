import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

class HomeModelView extends GetxController {
  var list_product = [].obs;

  GetAllProduct() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('product').get();
    list_product.value = querySnapshot.docs.map((doc) => doc.data()).toList();
  }
}
