import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:nieak/onlines/statepages/cart_state.dart';

class CartModelView extends GetxController{
  var list_cart = [].obs;

 getAllMapsInArray(String documentId) async {
    final listCheck = Get.put(CartState());
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final DocumentReference documentReference = _firestore.collection('user').doc(documentId);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    List<dynamic> arrayField = documentSnapshot['cart'];
    list_cart.value = arrayField.whereType<Map<String, dynamic>>().toList();
    listCheck.createList(list_cart.length);
  }

  deleteProductFromCart(String documentId,int i) async {
    final collectionRef = FirebaseFirestore.instance.collection('user');
    final documentRef = collectionRef.doc(documentId);
    final myArray = await documentRef.get().then((doc) => doc['cart']);
    myArray.removeAt(i);
    await documentRef.update({'cart': myArray});
    await getAllMapsInArray(documentId);
  }
}