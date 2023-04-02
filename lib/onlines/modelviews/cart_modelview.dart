import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CartModelView extends GetxController{
  var list_cart = [].obs;

 getAllMapsInArray(String documentId, String arrayFieldName) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final DocumentReference documentReference = _firestore.collection('user').doc(documentId);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    List<dynamic> arrayField = documentSnapshot[arrayFieldName];
    print(arrayField);
    list_cart.value = arrayField.whereType<Map<String, dynamic>>().toList();
  }
}