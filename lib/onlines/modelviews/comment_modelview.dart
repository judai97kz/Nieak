import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nieak/onlines/models/comment_model.dart';
import 'package:nieak/onlines/modelviews/home_modelview.dart';

List<String> banWord = [
  'buoi',
  'Buồi',
  'buồi',
  'Buoi',
  'lon',
  'Lon',
  'Lồn',
  'lồn',
  'lòn',
  'Lòn',
  'Chim',
  'chim'
];

class CommentModelView extends GetxController {
  var list_cmt = [].obs;
  var rate = 0.0.obs;
  getAllComment(String idproduct) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('comment')
        .where('idproduct', isEqualTo: idproduct)
        .get();
    list_cmt.value = querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  addComment(CommentModel newcmt, BuildContext context) async {
    final homeModel = Get.put(HomeModelView());
    var rating = 0.0;
    var checkWord = 0;
    for (int i = 0; i < banWord.length; i++) {
      if (newcmt.content.trim().contains(banWord[i])) {
        checkWord++;
      }
    }
    if (checkWord == 0) {
      await FirebaseFirestore.instance
          .collection('comment')
          .doc(newcmt.idcomment)
          .set(newcmt.toJson());
      await getAllComment(newcmt.idproduct);
      for (int i = 0; i < list_cmt.length; i++) {
        rating = rating + list_cmt[i]['rating'];
      }
      await FirebaseFirestore.instance
          .collection('product')
          .doc(newcmt.idproduct)
          .update({'rating': rating / list_cmt.length});
      await homeModel.GetAllProduct();
      var product = await homeModel.list_product
          .firstWhere((element) => element['idshoes'] == newcmt.idproduct);
      rate.value = await product['rating'];
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Bình luận có từ ngữ cấm")));
    }
  }
}
