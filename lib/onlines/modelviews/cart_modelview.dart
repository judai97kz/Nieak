
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:nieak/onlines/modelviews/home_modelview.dart';
import 'package:nieak/onlines/modelviews/user_state.dart';
import 'package:nieak/onlines/statepages/cart_state.dart';

class CartModelView extends GetxController{
  var list_cart = [].obs;

 getAllMapsInArray(String documentId) async {
    final listCheck = Get.put(CartState());
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final DocumentReference documentReference = _firestore.collection('user').doc(documentId.trim());
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

  addOrUpdateMap(String documentId, String fieldName,
      Map<String, dynamic> mapToAdd,int value) async {
    final userModel = Get.put(UserState());
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final DocumentReference documentReference =
    _firestore.collection('user').doc(documentId.trim());
    DocumentSnapshot docSnapshot = await documentReference.get();
    Map<String, dynamic> docData = docSnapshot.data() as Map<String, dynamic>;
    if (docData.containsKey(fieldName) && docData[fieldName] is List) {
      List<Map<String, dynamic>> mapList =
      List<Map<String, dynamic>>.from(docData[fieldName]);
      int existingMapIndex = mapList.indexWhere((element) =>
      element['idshoes'] == mapToAdd['idshoes'] &&
          element['size'] == mapToAdd['size']);
      mapList[existingMapIndex]['amount'] = value;
      getAllMapsInArray(userModel.user.value!.id);
      await documentReference.update({fieldName: mapList});
    } else {
      throw Exception('Invalid data structure or missing key');
    }
  }

  addAmount(Map<String,dynamic> shoe) async {
    final homeModel = Get.put(HomeModelView());
    final userModel = Get.put(UserState());
    var temp = homeModel.list_product.firstWhere((element) => element['idshoes']==shoe['idshoes']);
    Map<String, dynamic> mapToAdd = {
      'sale':shoe['sale'],
      'idshoes': shoe["idshoes"],
      'nameproduct': shoe["nameproduct"],
      'price': temp["price"],
      'image': shoe['image'],
      'size': shoe['size'],
      'amount': shoe['amount'],
    };
    if(shoe['amount']<temp['amount']) {
      await addOrUpdateMap(userModel.user.value!.id, 'cart', mapToAdd, shoe['amount']+1);
    }
  }
  removeAmount(Map<String,dynamic> shoe) async {

    final homeModel = Get.put(HomeModelView());
    final userModel = Get.put(UserState());
    var temp = homeModel.list_product.firstWhere((element) => element['idshoes']==shoe['idshoes']);
    Map<String, dynamic> mapToAdd = {
      'sale':shoe['sale'],
      'idshoes': shoe["idshoes"],
      'nameproduct': shoe["nameproduct"],
      'price': temp["price"],
      'image': shoe['image'],
      'size': shoe['size'],
      'amount': shoe['amount'],
    };
    if(shoe['amount']>1) {
      await addOrUpdateMap(userModel.user.value!.id, 'cart', mapToAdd, shoe['amount']-1);
    }
  }
}