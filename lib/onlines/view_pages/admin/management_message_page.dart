import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nieak/onlines/modelviews/home_modelview.dart';
import 'package:nieak/onlines/view_pages/chat_page.dart';

class ManagementMessagepage extends StatefulWidget {
  const ManagementMessagepage({Key? key}) : super(key: key);

  @override
  State<ManagementMessagepage> createState() => _ManagementMessagepageState();
}

class _ManagementMessagepageState extends State<ManagementMessagepage> {
  final chatRoomModel = Get.put(HomeModelView());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatRoomModel.getChatRoom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tin Nhắn Người Dùng"),
      ),
      body: Obx(() => chatRoomModel.list_chat_room.length == 0
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: chatRoomModel.list_chat_room.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => ChatPage(
                                idroom: chatRoomModel.list_chat_room[index]
                                    ['id'])));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              Container(
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      chatRoomModel.list_chat_room[index]
                                          ['imageAvatar'],
                                      height: 60,
                                      width: 60,
                                    ),
                                  ),
                                ),
                              ),
                              Text(chatRoomModel.list_chat_room[index]['name'])
                            ],
                          ),
                        )),
                  ),
                );
              },
            )),
    );
  }
}
