import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nieak/onlines/view_pages/home_page.dart';

import '../models/user_model.dart';
import '../modelviews/user_state.dart';

class CreateInfoPage extends StatefulWidget {
  const CreateInfoPage({Key? key}) : super(key: key);

  @override
  State<CreateInfoPage> createState() => _CreateInfoPageState();
}

class _CreateInfoPageState extends State<CreateInfoPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  PlatformFile? pickedFile;
  late File files;
  UploadTask? uploadTask;
  late String Url;
  final userstate = Get.put(UserState());
  final _nametextcontroller = TextEditingController();
  final _datetextcontroller = TextEditingController();
  final _mailtextcontroller = TextEditingController();
  final _phonetextcontroller = TextEditingController();
  final _addresstextcontroller = TextEditingController();

  Future selectFile() async {
    print("chon anh");
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future uploadFile() async {
    final path = 'User/${userstate.userinfo.value?.user!.uid}/Avatar';
    final file = File(pickedFile!.path.toString());
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);
    final snapshot = await uploadTask!.whenComplete(() => null);
    final urlDL = await snapshot.ref.getDownloadURL();
    setState(() {
      Url = urlDL;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/public/bg1.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Image.asset('assets/public/bg1.jpg'),
              GestureDetector(
                onTap: selectFile,
                child: CircleAvatar(
                  child: pickedFile == null
                      ? Icon(Icons.add_a_photo)
                      : Image.memory(File(pickedFile!.path!).readAsBytesSync()),
                ),
              ),
              TextField(
                controller: _nametextcontroller,
              ), //Nhập tên
              TextField(
                controller: _datetextcontroller,
              ), //Nhập ngày sinh
              TextField(
                controller: _mailtextcontroller,
              ), //gmail
              TextField(
                controller: _phonetextcontroller,
              ), //Nhập số điện thoại
              TextField(controller: _addresstextcontroller), //Nhập địa chỉ
              ElevatedButton(
                  onPressed: () async {
                    await uploadFile();
                    UserModel newuser = UserModel(
                        name: _nametextcontroller.text,
                        phone: _phonetextcontroller.text,
                        address: _addresstextcontroller.text,
                        idcart: "Judai4234",
                        imageAvatar: Url,
                        wallet: 1233435435,
                        role: 1);
                    firestore
                        .collection("user")
                        .doc(userstate.userinfo.value!.user!.uid)
                        .set(newuser.toJson());
                    try {
                      final CollectionReference myCollectionRef =
                          FirebaseFirestore.instance.collection('user');
                      final DocumentReference myDocRef = myCollectionRef
                          .doc(userstate.userinfo.value!.user!.uid);
                      final docSnapshot = await myDocRef.get();
                      if (docSnapshot.exists) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => MyWidget(),
                          ),
                        );
                      } else {
                        firestore
                            .collection("user")
                            .doc(userstate.userinfo.value!.user!.uid)
                            .set(newuser.toJson());
                      }
                    } catch (e) {
                      // Xử lý lỗi nếu có
                    }
                  },
                  child: Text("Cập nhật thông tin"))
            ],
          ),
        ),
      ),
    );
  }
}
