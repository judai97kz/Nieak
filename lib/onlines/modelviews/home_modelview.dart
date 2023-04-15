import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeModelView extends GetxController {
  var list_product = [].obs;
  var list_banner = [].obs;
  var list_brand = [].obs;
  var list_user = [].obs;
  var find_result = false.obs;
  var list_chat_room = [].obs;

  GetAllBrand() async {
    CollectionReference myCollection =
        FirebaseFirestore.instance.collection('categories');
    DocumentSnapshot myDocument = await myCollection.doc('Brand').get();
    List<dynamic> myArray = myDocument['brands'];
    print(myArray);
    list_brand.value = myArray;
  }

  addCategory(String brand) async {
    final collectionRef = FirebaseFirestore.instance.collection('categories');
    final documentRef = collectionRef.doc('Brand');
    final myArray = await documentRef.get().then((doc) => doc['brands']);
    myArray.add(brand);
    await documentRef.update({'brands': myArray});
    await GetAllBrand();
  }

  deleteCategory(int i) async {
    final collectionRef = FirebaseFirestore.instance.collection('categories');
    final documentRef = collectionRef.doc('Brand');
    final myArray = await documentRef.get().then((doc) => doc['brands']);
    myArray.removeAt(i);
    await documentRef.update({'brands': myArray});
    await GetAllBrand();
  }

  GetAllProduct() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('product').get();
    list_product.value = querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  GetProductTemp(String key) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('product').get();
    final listTemp = querySnapshot.docs.map((doc) => doc.data()).toList();
    list_product.value = listTemp
        .where((element) =>
            element['nameshoes'].contains(key.toLowerCase().capitalize))
        .toList();
    if (list_product.value.length == 0) {
      find_result.value = true;
    } else {
      find_result.value = false;
    }
  }

  GetProductAdmin(String key) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('product').get();
    final listTemp = querySnapshot.docs.map((doc) => doc.data()).toList();
    list_product.value = listTemp
        .where((element) =>
            element['idshoes'].contains(key.toLowerCase().capitalize))
        .toList();
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
        await usersRef.where('role', isEqualTo: 0).get();
    list_user.value = snapshot.docs.map((doc) => doc.data()).toList();
  }

  updateAmount(String key, int amount) {
    FirebaseFirestore.instance
        .collection("product")
        .doc(key.trim())
        .get()
        .then((documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Data found: ${documentSnapshot.data()!['amount']}');
        FirebaseFirestore.instance
            .collection("product")
            .doc(key.trim())
            .update({'amount': documentSnapshot.data()!['amount'] - amount});
      } else {
        print('Document does not exist on the database');
      }
    }).catchError((error) {
      print('Failed to get document: $error');
    });
  }

  getChatRoom() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('user')
        .where('role', isEqualTo: 0)
        .where('disable', isEqualTo: false)
        .get();
    list_chat_room.value = querySnapshot.docs.map((doc) => doc.data()).toList();
  }
}
