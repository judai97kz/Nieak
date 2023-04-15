import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nieak/onlines/modelviews/home_modelview.dart';

class ManagementCategoryPage extends StatefulWidget {
  const ManagementCategoryPage({Key? key}) : super(key: key);

  @override
  State<ManagementCategoryPage> createState() => _ManagementCategoryPageState();
}

class _ManagementCategoryPageState extends State<ManagementCategoryPage> {
  final listBrand = Get.put(HomeModelView());
  final value = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quản Lý Thương Hiệu"),
      ),
      body: Obx(() => listBrand.list_brand.length == 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: listBrand.list_brand.length,
              itemBuilder: (context, index) {
                return listBrand.list_brand[index] == "All"
                    ? SizedBox(
                        height: 0,
                      )
                    : Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 25,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                  child: Text(listBrand.list_brand[index])),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  AlertDialog dialog = AlertDialog(
                                    title: Text("Thông Báo"),
                                    content:
                                        Text("Bạn có muốn thương hiệu này?"),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () async {
                                            listBrand.deleteCategory(index);
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Đã xóa sản phẩm")));
                                          },
                                          child: Text("Xác nhận")),
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Hủy"))
                                    ],
                                  );
                                  showDialog(
                                      context: context,
                                      builder: (context) => dialog);
                                },
                                child: Icon(Icons.remove_circle),
                              ),
                            )
                          ],
                        ));
              },
            )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AlertDialog dialog = AlertDialog(
            title: Text("Nhập tên thương hiệu"),
            content: TextField(
              controller: value,
            ),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    if (value.text != "") {
                      listBrand.addCategory(value.text);
                      value.clear();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Thêm thương hiệu thành công!")));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Không được để trống!")));
                    }
                  },
                  child: Text("Xác nhận")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Hủy"))
            ],
          );
          showDialog(context: context, builder: (context) => dialog);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
