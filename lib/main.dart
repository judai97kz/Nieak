import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nieak/onlines/statepages/startup_state.dart';
import 'onlines/modelviews/login_modelview.dart';
import 'onlines/view_pages/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: Scaffold(
      body: SafeArea(child: StartUp()),
    ),
  ));
}

class StartUp extends StatefulWidget {
  const StartUp({Key? key}) : super(key: key);

  @override
  State<StartUp> createState() => _StartUpState();
}

class _StartUpState extends State<StartUp> {
  final startupstate = Get.put(StartUpState());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startupstate.CheckAuto(context);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(()=> startupstate.checkstartup == true
        ? LoginPage()
        : Container(child: Center(child: CircularProgressIndicator())));
  }
}
