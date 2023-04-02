import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

class HomeModelView extends GetxController {
  var list_product = [].obs;
  var list_banner = [].obs;
  var list_brand = [].obs;

  GetAllBrand() async {
    CollectionReference myCollection =
    FirebaseFirestore.instance.collection('categories');
    DocumentSnapshot myDocument = await myCollection.doc('Brand').get();
    List<dynamic> myArray = myDocument['brands'];
    print(myArray);
    list_brand.value= myArray;
  }

  GetAllProduct() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('product').get();
    list_product.value = querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  GetImageBanner() async {
    CollectionReference myCollection =
        FirebaseFirestore.instance.collection('imagebanner');
    DocumentSnapshot myDocument = await myCollection.doc('image1').get();
    List<dynamic> myArray = myDocument['image'];
    print(myArray);
    list_banner.value= myArray;
  }

  GetProductByBrand(String brand) async {
    final CollectionReference usersRef = FirebaseFirestore.instance.collection('product');
    final QuerySnapshot snapshot = await usersRef.where('brand', isEqualTo: brand).get();
    list_product.value = snapshot.docs.map((doc) => doc.data()).toList();
  }
}
