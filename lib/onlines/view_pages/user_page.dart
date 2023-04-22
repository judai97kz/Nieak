import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nieak/onlines/modelviews/cart_modelview.dart';
import 'package:nieak/onlines/modelviews/user_state.dart';
import 'package:nieak/onlines/statepages/createinfo_state.dart';
import 'package:nieak/onlines/statepages/management_state.dart';
import 'package:nieak/onlines/statepages/user_info_state.dart';
import 'package:nieak/onlines/view_pages/bill_page.dart';
import 'package:nieak/onlines/view_pages/chat_page.dart';
import 'package:nieak/onlines/view_pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final userState = Get.put(UserState());
  final userInfo = Get.put(UserInfoState());
  final cartModel = Get.put(CartModelView());
  final changeDay = Get.put(CreateInfoState());
  final _editname = TextEditingController();
  final _editphone = TextEditingController();
  final _editaddress = TextEditingController();

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    if (result == null) return;
    setState(() {
      userInfo.selectedFile.value = result.files.first;
    });
  }

  void _editInfo(String field, TextEditingController value, String title) {
    AlertDialog dialog = AlertDialog(
      title: Text("Chỉnh sửa ${title}"),
      content: TextField(
        controller: value,
      ),
      actions: [
        ElevatedButton(
            onPressed: () async {
              if (value.text != "") {
                await FirebaseFirestore.instance
                    .collection('user')
                    .doc(userState.uidtemp.trim())
                    .update({field: value.text});
                userState.InfoUser(userState.uidtemp.trim());
                value.clear();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Thay đổi thông tin thành công!")));
              } else {
                Navigator.pop(context);
              }
            },
            child: Text("Xác nhận")),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Hủy"))
      ],
    );
    showDialog(context: context, builder: (context) => dialog);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Thông Tin Cá Nhân"),
        actions: [
          GestureDetector(
            onTap: () {
              AlertDialog dialog = AlertDialog(
                title: Text("Thông Báo"),
                content: Text("Bạn có muốn đăng xuất khỏi ứng dụng?"),
                actions: [
                  ElevatedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.remove('uid');
                        final homemana = Get.put(ManagementState());
                        homemana.currentindex.value = 0;
                        userState.user.value = null;
                        userState.userinfo.value = null;
                        cartModel.list_cart.value = [];
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                            (Route<dynamic> route) => false);
                      },
                      child: Text("Xác nhận")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Hủy"))
                ],
              );
              showDialog(context: context, builder: (context) => dialog);
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.logout,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => Container(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      child: Image.asset(
                        "assets/public/sbg.jpg",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        AlertDialog dialog = AlertDialog(
                          content: Obx(() => userInfo.selectedFile.value != null
                              ? Image.memory(
                                  File(userInfo.selectedFile.value!.path!)
                                      .readAsBytesSync())
                              : Image.network(
                                  userState.user.value!.imageAvatar)),
                          actionsAlignment: MainAxisAlignment.center,
                          actions: [
                            Obx(
                              () => userInfo.selectedFile.value == null
                                  ? ElevatedButton(
                                      onPressed: () {
                                        selectFile();
                                      },
                                      child: Text("Thay đổi Avatar"))
                                  : ElevatedButton(
                                      onPressed: () async {
                                        await userInfo.uploadFile();
                                        await userState.InfoUser(
                                            userState.uidtemp.trim());
                                      },
                                      child: Text("Cập nhật ảnh")),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  userInfo.selectedFile.value = null;
                                  Navigator.of(context).pop();
                                },
                                child: Text("Hủy"))
                          ],
                        );
                        showDialog(
                            context: context, builder: (context) => dialog);
                      },
                      child: Center(
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(95),
                                  border: Border.all(
                                      color: Colors.white, width: 3)),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(90),
                                  child: Image.network(
                                    userState.user.value!.imageAvatar,
                                    width: 150, // Thiết lập kích thước ảnh
                                    height: 150,
                                    fit: BoxFit.cover,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Container(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _editInfo('name', _editname, "tên người dùng");
                          },
                          child: Container(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      "Họ Tên Người Dùng: ${userState.user.value!.name}"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    child: Icon(Icons.edit),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12)),
                        ),
                        Container(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    "Ngày Sinh: ${userState.user.value!.birthday}"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    await changeDay.selectDate(context);
                                    await FirebaseFirestore.instance
                                        .collection('user')
                                        .doc(userState.uidtemp.trim())
                                        .update({
                                      'birthday':
                                          changeDay.dateTime.value.toString()
                                    }).then((value) => userState.InfoUser(
                                            userState.uidtemp.trim()));
                                  },
                                  child: Icon(Icons.edit),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12)),
                        ),
                        GestureDetector(
                          onTap: () {
                            _editInfo('phone', _editphone, "số điện thoại");
                          },
                          child: Container(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      "Số Điện Thoại: ${userState.user.value!.phone}"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    child: Icon(Icons.edit),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12)),
                        ),
                        GestureDetector(
                          onTap: () {
                            _editInfo('address', _editaddress, "địa chỉ");
                          },
                          child: Container(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      "Địa Chỉ: ${userState.user.value!.address}"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    child: Icon(Icons.edit),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black12)),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (builder) => BillPage()));
                    },
                    child: Text("Lịch Sử Mua Hàng"))
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (builder) =>
                      ChatPage(idroom: userState.user.value!.id)));
        },
        child: Icon(Icons.support_agent),
      ),
    );
  }
}
