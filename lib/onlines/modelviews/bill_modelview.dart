import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BillModelView extends GetxController {
  var list_bill = [].obs;
  var list_bill_admin = [].obs;
  getBillUser(String iduser) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('bill')
        .where('iduser', isEqualTo: iduser)
        .get();
    list_bill.value = querySnapshot.docs.map((doc) => doc.data()).toList();
  }
  makeABill(){

  }
  getAllBill() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('bill')
        .get();
    list_bill_admin.value = querySnapshot.docs.map((doc) => doc.data()).toList();
  }
  updateAcceptState(String id){
    print(id);
    FirebaseFirestore.instance
        .collection('bill')
        .doc(id)
        .update({'acceptstate': true});
    getAllBill();
  }
  updateReveiceState(String id,String iduser){
    print(id);
    FirebaseFirestore.instance
        .collection('bill')
        .doc(id)
        .update({'receivestate': true});
    getAllBill();
    getBillUser(iduser);
  }
  deleteBill(String id,String iduser){
    FirebaseFirestore.instance.collection('bill').doc(id).delete();
    getBillUser(iduser);
  }

}
