import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nieak/onlines/modelviews/user_state.dart';
import 'package:nieak/onlines/statepages/management_state.dart';
import 'package:nieak/onlines/view_pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final userState = Get.put(UserState());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                child: Center(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        userState.user.value!.imageAvatar,
                        width: 100, // Thiết lập kích thước ảnh
                        height: 100,
                        fit: BoxFit.cover,
                      )),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                child: Column(
                  children: [
                    Container(
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
                              child: Icon(Icons.edit),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
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
                    Container(
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
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
