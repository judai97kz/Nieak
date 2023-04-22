import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DisconnectPage extends StatefulWidget {
  const DisconnectPage({Key? key}) : super(key: key);

  @override
  State<DisconnectPage> createState() => _DisconnectPageState();
}

class _DisconnectPageState extends State<DisconnectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Center(child: Image.asset("assets/public/disconnect.png",height: 150,)),
        Text("Không Có Kết Nối Internet. Xin hãy thử lại!"),
        ElevatedButton(onPressed: (){SystemNavigator.pop();}, child: Text("Thoát Ứng Dụng"))],
      ),
    );
  }
}
