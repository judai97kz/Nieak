import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nieak/onlines/statepages/startup_state.dart';
import 'package:nieak/onlines/view_pages/disconnect_page.dart';
import 'onlines/view_pages/login_page.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
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
    try{
      startupstate.checkConnect(context);
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(()=>startupstate.check_connect==false?DisconnectPage():Obx(()=> startupstate.checkstartup == true
        ? LoginPage()
        : Container(child: Center(child: CircularProgressIndicator()))));
  }
}
