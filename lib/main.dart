import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'onlines/modelviews/login_modelview.dart';
import 'onlines/view_pages/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: Scaffold(
      body: StartUp(),
    ),
  ));
}

class StartUp extends StatefulWidget {
  const StartUp({Key? key}) : super(key: key);

  @override
  State<StartUp> createState() => _StartUpState();
}

class _StartUpState extends State<StartUp> {
  // Future<void> add_admin() async {
  //   User user = User(username: 'admin972001',
  //       password: 'admin972001',
  //       name: 'Admin_Judai',
  //       phone: '0367989659',
  //       address: '',
  //       idcart: 'admin',
  //       wallet: 999999999999999,
  //       role: 1);
  //   final FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   firestore.collection('admin').doc('admin').set(user.toJson());
  //
  // }
  final loginaction = LoginModelView();
  final username = TextEditingController();
  final password = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return LoginPage();
  }
}

