import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeModelView extends GetxController {
  var list_product = [].obs;
  var list_banner = [].obs;
  var list_brand = [].obs;
  var list_user = [].obs;

  GetAllBrand() async {
    CollectionReference myCollection =
        FirebaseFirestore.instance.collection('categories');
    DocumentSnapshot myDocument = await myCollection.doc('Brand').get();
    List<dynamic> myArray = myDocument['brands'];
    print(myArray);
    list_brand.value = myArray;
  }

  GetAllProduct() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('product').get();
    list_product.value = querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  GetProductTemp(String key) async {
    print(key);
    QuerySnapshot<Map<String, dynamic>> myDocument = await FirebaseFirestore
        .instance
        .collection('product')
        .where('nameshoes', isGreaterThanOrEqualTo: 'Nike 1')
        .get();
    print(myDocument.docs);
  }

  GetImageBanner() async {
    CollectionReference myCollection =
        FirebaseFirestore.instance.collection('imagebanner');
    DocumentSnapshot myDocument = await myCollection.doc('image1').get();
    List<dynamic> myArray = myDocument['image'];
    list_banner.value = myArray;
  }

  GetProductByBrand(String brand) async {
    final CollectionReference usersRef =
        FirebaseFirestore.instance.collection('product');
    final QuerySnapshot snapshot =
        await usersRef.where('brand', isEqualTo: brand).get();
    list_product.value = snapshot.docs.map((doc) => doc.data()).toList();
  }

  GetAllUser() async {
    final CollectionReference usersRef =
    FirebaseFirestore.instance.collection('user');
    final QuerySnapshot snapshot =
        await usersRef.where('role',isEqualTo: 0).get();
    list_user.value = snapshot.docs.map((doc) => doc.data()).toList();
  }
}
