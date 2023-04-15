import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nieak/onlines/modelviews/cart_modelview.dart';
import 'package:nieak/onlines/modelviews/user_state.dart';
import 'package:nieak/onlines/statepages/management_state.dart';
import 'package:nieak/onlines/view_pages/admin/add_new_product_page.dart';
import 'package:nieak/onlines/view_pages/admin/admin_page.dart';
import 'package:nieak/onlines/view_pages/cart_page.dart';
import 'package:nieak/onlines/view_pages/home_page.dart';
import 'package:nieak/onlines/view_pages/user_page.dart';

class ManagementPage extends StatefulWidget {
  const ManagementPage({Key? key}) : super(key: key);
  @override
  State<ManagementPage> createState() => _ManagementPageState();
}

class _ManagementPageState extends State<ManagementPage> {
  final managementState = Get.put(ManagementState());
  final cartState = Get.put(CartModelView());
  final roleuser = Get.put(UserState());
  var _screen = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _screen = [
      HomePage(),
      CartPage(),
      UserPage(),
      roleuser.user.value!.role == 1 ? AdminPage() : null
    ];
    cartState.getAllMapsInArray(roleuser.uidtemp.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => roleuser.user.value == null
          ? Scaffold(
              body: CircularProgressIndicator(),
            )
          : Scaffold(
              body: _screen[managementState.currentindex.value],
              bottomNavigationBar: roleuser.user.value!.role == 1
                  ? Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      child: BottomNavigationBar(
                        type: BottomNavigationBarType.fixed,
                        currentIndex: managementState.currentindex.value,
                        onTap: (index) => setState(() {
                          print(index);
                          managementState.currentindex.value = index;
                        }),
                        items: [
                          BottomNavigationBarItem(
                              icon: Icon(Icons.home),
                              label: 'Home',
                              backgroundColor: Colors.red),
                          BottomNavigationBarItem(
                              icon: Stack(children: [
                                const Align(
                                  alignment: Alignment.center,
                                  child: Icon(Icons.shopping_cart),
                                ),
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: Obx(() => Padding(
                                          padding: MediaQuery.of(context)
                                                      .orientation ==
                                                  Orientation.portrait
                                              ? roleuser.user.value!.role == 1
                                                  ? EdgeInsets.fromLTRB(
                                                      0, 0, 25, 15)
                                                  : EdgeInsets.fromLTRB(
                                                      0, 0, 45, 20)
                                              : roleuser.user.value!.role == 1
                                                  ? EdgeInsets.fromLTRB(
                                                      0, 0, 60, 0)
                                                  : EdgeInsets.fromLTRB(
                                                      0, 0, 95, 0),
                                          child: CircleAvatar(
                                            radius: 7,
                                            backgroundColor: Colors.red,
                                            child: Text(
                                              cartState.list_cart.length
                                                  .toString(),
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                          ),
                                        ))),
                              ]),
                              label: 'Cart',
                              backgroundColor: Colors.red),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.person), label: 'User'),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.admin_panel_settings),
                              label: 'Admin')
                        ],
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      child: BottomNavigationBar(
                        type: BottomNavigationBarType.fixed,
                        currentIndex: managementState.currentindex.value,
                        onTap: (index) => setState(() {
                          print(index);
                          managementState.currentindex.value = index;
                        }),
                        items: [
                          BottomNavigationBarItem(
                              icon: Icon(Icons.home),
                              label: 'Home',
                              backgroundColor: Colors.red),
                          BottomNavigationBarItem(
                              icon: Stack(children: [
                                const Align(
                                  alignment: Alignment.center,
                                  child: Icon(Icons.shopping_cart),
                                ),
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: Obx(() => Padding(
                                          padding: MediaQuery.of(context)
                                                      .orientation ==
                                                  Orientation.portrait
                                              ? roleuser.user.value!.role == 1
                                                  ? EdgeInsets.fromLTRB(
                                                      0, 0, 25, 20)
                                                  : EdgeInsets.fromLTRB(
                                                      0, 0, 45, 20)
                                              : roleuser.user.value!.role == 1
                                                  ? EdgeInsets.fromLTRB(
                                                      0, 0, 65, 0)
                                                  : EdgeInsets.fromLTRB(
                                                      0, 0, 95, 0),
                                          child: CircleAvatar(
                                            radius: 7,
                                            backgroundColor: Colors.red,
                                            child: Text(
                                              cartState.list_cart.length
                                                  .toString(),
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                          ),
                                        ))),
                              ]),
                              label: 'Cart',
                              backgroundColor: Colors.red),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.person), label: 'User'),
                        ],
                      ),
                    )),
    );
  }
}
