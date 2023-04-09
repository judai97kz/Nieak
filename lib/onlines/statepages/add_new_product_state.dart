import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nieak/onlines/models/shoes_model.dart';
import 'package:nieak/onlines/modelviews/home_modelview.dart';

class AddNewProductState extends GetxController {
  var idtext = "".obs;
  var nametext = "".obs;
  var brandtext = "".obs;
  var pricetext = "".obs;
  var mintext = "".obs;
  var maxtext = "".obs;
  var amounttext = "".obs;
  var colortext = "".obs;

  var ListUrl = <String>[].obs;
  var files = [].obs;
  var defaulValue = "".obs;

  checkNull(
      String id,
      String name,
      String brand,
      String price,
      String min,
      String max,
      String amount,
      String color,
      List<File> files,
      BuildContext context) async {
    final homestate = Get.put(HomeModelView());
    if (id == "") {
      idtext.value = "Không được để trống!";
      return;
    }
    idtext.value = "";
    if (name == "") {
      nametext.value = "Không được để trống!";
      return;
    }
    nametext.value = "";
    if (brand == "") {
      brandtext.value = "Không được để trống!";
      return;
    }
    brandtext.value = "";
    if (price == "") {
      pricetext.value = "Không được để trống!";
      return;
    }
    pricetext.value = "";
    if (min == "") {
      mintext.value = "Không được để trống!";
      return;
    }
    mintext.value = "";
    if (max == "") {
      maxtext.value = "Không được để trống!";
      return;
    }
    if (int.parse(min) > int.parse(max)) {
      maxtext.value = "Kích thước tối đa phải lớn hơn kích thước tối thiểu!";
      return;
    }
    maxtext.value = "";
    if (amount == "") {
      amounttext.value = "Không được để trống!";
      return;
    }
    amounttext.value = "";
    if (color == "") {
      colortext.value = "Không được để trống!";
      return;
    }
    colortext.value = "";
    final CollectionReference myCollectionRef =
        FirebaseFirestore.instance.collection('product');
    final DocumentReference myDocRef = myCollectionRef.doc(id);
    final docSnapshot = await myDocRef.get();
    if (!docSnapshot.exists) {
      UploadTask? uploadTask;
      for (int i = 0; i < files.length; i++) {
        final path = 'Products/${id}/${i}';
        final file = File(files[i].path);
        final ref = FirebaseStorage.instance.ref().child(path);
        uploadTask = ref.putFile(file);
        final snapshot = await uploadTask!.whenComplete(() => null);
        final urlDL = await snapshot.ref.getDownloadURL();
        ListUrl.add(urlDL.toString());
      }
      ShoesModel newshoe = ShoesModel(
          idshoes: id,
          nameshoes: name,
          image: ListUrl,
          imagenumber: ListUrl.length,
          price: int.parse(price),
          amount: int.parse(amount),
          rating: 0.0,
          brand: brand,
          minSize: int.parse(min),
          maxSize: int.parse(max),
          color: color,
          dateadd: DateTime.now().toString());
      FirebaseFirestore.instance
          .collection("product")
          .doc(id)
          .set(newshoe.toJson());

      ListUrl.value = [];
      homestate.GetAllProduct();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thêm Sản Phẩm Thành Công!')));

    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Sản Phẩm Đã Tồn Tại!')));
    }
  }
}
