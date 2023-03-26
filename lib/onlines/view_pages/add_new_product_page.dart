import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nieak/onlines/modelviews/home_modelview.dart';
import '../models/shoes_model.dart';

class AddNewProductPage extends StatefulWidget {
  const AddNewProductPage({Key? key}) : super(key: key);
  @override
  State<AddNewProductPage> createState() => _AddNewProductPageState();
}

class _AddNewProductPageState extends State<AddNewProductPage> {
  PlatformFile? pickedFile;
  List<File> files = [];
  UploadTask? uploadTask;
  List<String> ListUrl = [];
  final homestate = Get.put(HomeModelView());
  final _idshoes = TextEditingController();
  final _nameshoes = TextEditingController();
  final _priceshoes = TextEditingController();
  final _amoutshoes = TextEditingController();
  final _minshoes = TextEditingController();
  final _maxshoes = TextEditingController();
  final _colorshoes = TextEditingController();
  final _brandshoes = TextEditingController();
  Future selectFile() async {
    print("chon anh");
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    if (result == null) return;
    setState(() {
      files = result.paths.map((path) => File(path!)).toList();
    });
  }

  Future uploadFile() async {
    for (int i = 0; i < files.length; i++) {
      final path = 'Products/Nike3/${i}';
      final file = File(files[i].path);
      final ref = FirebaseStorage.instance.ref().child(path);
      uploadTask = ref.putFile(file);
      final snapshot = await uploadTask!.whenComplete(() => null);
      final urlDL = await snapshot.ref.getDownloadURL();
      ListUrl.add(urlDL.toString());
      ShoesModel newshoe = ShoesModel(
          idshoes: _idshoes.text,
          nameshoes: _nameshoes.text,
          image: ListUrl,
          imagenumber: ListUrl.length,
          price: int.parse(_priceshoes.text),
          amount: int.parse(_amoutshoes.text),
          rating: 0.0,
          brand: _brandshoes.text,
          minSize: int.parse(_minshoes.text),
          maxSize: int.parse(_maxshoes.text),
          color: _colorshoes.text,
          dateadd: DateTime.now().toString());
      FirebaseFirestore.instance
          .collection("product")
          .doc(_idshoes.text)
          .set(newshoe.toJson());
      files = [];
      ListUrl = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        files = [];
        ListUrl = [];
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              files = [];
              ListUrl = [];
            },
          ),
        ),
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              files.length == 0
                  ? Text("Null")
                  : Container(
                      height: 250,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: files.length,
                          itemBuilder: (context, index) => Container(
                              height: 50, child: Image.file(files[index]))),
                    ),
              ElevatedButton(
                  onPressed: () {
                    selectFile();
                  },
                  child: Text("Chon anh")),
              TextField(
                controller: _idshoes,
                decoration: InputDecoration(labelText: "Mã sản phẩm"),
              ), //Ma sp
              TextField(
                  controller: _nameshoes,
                  decoration:
                      InputDecoration(labelText: "Tên sản phẩm")), //ten sp
              TextField(
                  controller: _brandshoes,
                  decoration:
                      InputDecoration(labelText: "Hãng sản xuất")), //hang
              TextField(
                  controller: _priceshoes,
                  decoration: InputDecoration(labelText: "Giá sản phẩm")), //gia
              TextField(
                  controller: _minshoes,
                  decoration:
                      InputDecoration(labelText: "Kích thước tối thiểu")), //min
              TextField(
                  controller: _maxshoes,
                  decoration:
                      InputDecoration(labelText: "Kích thước tối đa")), //max
              TextField(
                  controller: _amoutshoes,
                  decoration: InputDecoration(labelText: "Số lượng")), //solg
              TextField(
                  controller: _colorshoes,
                  decoration: InputDecoration(labelText: "Mầu")), //mau
              ElevatedButton(
                  onPressed: () async {
                    await uploadFile();
                    homestate.GetAllProduct();
                  },
                  child: Text("Gui Anh"))
            ],
          ),
        ),
      ),
    );
  }
}
