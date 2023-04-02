import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nieak/onlines/statepages/createinfo_state.dart';
import 'package:nieak/onlines/view_pages/home_page.dart';
import 'package:nieak/onlines/view_pages/management_page.dart';

import '../models/user_model.dart';
import '../modelviews/user_state.dart';

class CreateInfoPage extends StatefulWidget {
  const CreateInfoPage({Key? key}) : super(key: key);

  @override
  State<CreateInfoPage> createState() => _CreateInfoPageState();
}

class _CreateInfoPageState extends State<CreateInfoPage> {
  PlatformFile? pickedFile;
  late File files;

  late String Url;
  final userstate = Get.put(UserState());
  final _nametextcontroller = TextEditingController();
  final _mailtextcontroller = TextEditingController();
  final _phonetextcontroller = TextEditingController();
  final _addresstextcontroller = TextEditingController();
  final createinfoState = Get.put(CreateInfoState());
  final roleuser = Get.put(UserState());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Thông Tin Cá Nhân",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                      color: Colors.black54),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: selectFile,
                  child: pickedFile == null
                      ? Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black)),
                          child: Icon(Icons.add_a_photo),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.memory(
                              width: 100, // Thiết lập kích thước ảnh
                              height: 100,
                              fit: BoxFit.cover,
                              File(pickedFile!.path!).readAsBytesSync())),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
                  child: Obx(
                    () => TextField(
                      decoration: InputDecoration(
                          hintText: "Tên người dùng",
                          errorText: createinfoState.fullname.value == ""
                              ? null
                              : createinfoState.fullname.value),
                      controller: _nametextcontroller,
                    ),
                  ),
                ), //Nhập tên
                Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
                    child: GestureDetector(
                      onTap: () {
                        createinfoState.selectDate(context);
                      },
                      child: Obx(
                        () => Container(
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              border: Border.all(color: Colors.black54),
                              borderRadius: BorderRadius.circular(10)),
                          child: createinfoState.dateTime == ""
                              ? Center(child: Text("Ngày sinh"))
                              : Center(
                                  child: Text("${createinfoState.dateTime}")),
                        ),
                      ),
                    )), //Nhập ngày sinh
                roleuser.userinfo.value!.user!.email != null
                    ? SizedBox(
                        height: 0,
                      )
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
                        child: Obx(
                          () => TextField(
                            decoration: InputDecoration(
                                hintText: "email",
                                errorText: createinfoState.gmailtext.value == ""
                                    ? null
                                    : createinfoState.gmailtext.value),
                            controller: _mailtextcontroller,
                          ),
                        ),
                      ), //gmail
                roleuser.userinfo.value!.user!.phoneNumber != null
                    ? SizedBox(
                        height: 0,
                      )
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
                        child: Obx(
                          () => TextField(
                            decoration: InputDecoration(
                                hintText: "Số điện thoại",
                                errorText: createinfoState.phonetext == ""
                                    ? null
                                    : createinfoState.phonetext.value),
                            controller: _phonetextcontroller,
                          ),
                        ),
                      ), //Nhập số điện thoại
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
                  child: Obx(
                    () => TextField(
                        decoration: InputDecoration(
                            hintText: "Địa chỉ",
                            errorText: createinfoState.addresstext.value == ""
                                ? null
                                : createinfoState.addresstext.value),
                        controller: _addresstextcontroller),
                  ),
                ), //Nhập địa chỉ
                ElevatedButton(
                    onPressed: () async {
                      createinfoState.CheckNull(
                          _nametextcontroller.text,
                          createinfoState.dateTime.toString(),
                          _mailtextcontroller.text,
                          _phonetextcontroller.text,
                          _addresstextcontroller.text,
                          pickedFile,
                          context);
                    },
                    child: Text("Cập nhật thông tin")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
