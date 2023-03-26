import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nieak/onlines/mini_widget/product_widget.dart';
import 'package:nieak/onlines/view_pages/add_new_product_page.dart';
import 'package:nieak/onlines/view_pages/info_product_page.dart';

import '../modelviews/home_modelview.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final homeState = Get.put(HomeModelView());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homeState.GetAllProduct();
  }

  @override
  Widget build(BuildContext context) {
    print(homeState.list_product.length);
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Container(
        child: Scaffold(
            appBar: AppBar(
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => AddNewProductPage()));
                    },
                    child: Text("Hello"))
              ],
              title: Text("NIEAK"),
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    // Some other widgets
                    Obx(() => homeState.list_product.length == 0
                        ? CircularProgressIndicator()
                        : Container(
                            height: 2000,
                            child: GridView.builder(
                              itemCount: homeState.list_product.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 7 / 8,
                                crossAxisSpacing: 0.0,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (builder) =>
                                                InfoProductPage(
                                                    shoe: homeState
                                                        .list_product[index])));
                                  },
                                  child: MiniProduct(
                                      context, homeState.list_product[index]),
                                );
                              },
                            ),
                          ))
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
