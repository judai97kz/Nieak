import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:nieak/onlines/mini_widget/management_user_widget.dart';
import 'package:nieak/onlines/modelviews/home_modelview.dart';

class ManagementUserPage extends StatefulWidget {
  const ManagementUserPage({Key? key}) : super(key: key);

  @override
  State<ManagementUserPage> createState() => _ManagementUserPageState();
}

class _ManagementUserPageState extends State<ManagementUserPage> {
  final homeState = Get.put(HomeModelView());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homeState.GetAllUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quản lý người dùng"),
      ),
      body: Obx(()=>homeState.list_user.length==0?CircularProgressIndicator():ListView.builder(
        itemCount: homeState.list_user.length,
        itemBuilder: (context,index){
          return ManagementUserWidget(homeState.list_user[index]);
        },
      )),
    );
  }
}
