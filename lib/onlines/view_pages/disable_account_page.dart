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
      appBar: AppBar(
        title: Text("Thông báo"),
      ),
      body: Center(
        child: Text("Tài khoản của bạn đã bị vô hiệu hóa do vi phạm chính sách của chúng tôi!",textAlign: TextAlign.center,),
      ),
    );
  }
}
