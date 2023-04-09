import 'package:flutter/material.dart';

class DisableAccountPage extends StatefulWidget {
  const DisableAccountPage({Key? key}) : super(key: key);

  @override
  State<DisableAccountPage> createState() => _DisableAccountPageState();
}

class _DisableAccountPageState extends State<DisableAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text("Tai khoan ban da bi vo hieu hoa do vi pham chinh sach su dung cua chung toi"),
      ),
    );
  }
}
