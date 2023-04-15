import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisableAccountPage extends StatefulWidget {
  const DisableAccountPage({Key? key}) : super(key: key);

  @override
  State<DisableAccountPage> createState() => _DisableAccountPageState();
}

class _DisableAccountPageState extends State<DisableAccountPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('uid');
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Thông báo"),
          leading: BackButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('uid');
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/public/image.png',
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Tài khoản của bạn đã bị vô hiệu hóa do vi phạm chính sách của chúng tôi!",
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
