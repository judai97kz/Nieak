import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nieak/onlines/mini_widget/management_product_widget.dart';
import 'package:nieak/onlines/modelviews/home_modelview.dart';
import 'package:nieak/onlines/view_pages/add_new_product_page.dart';

class ManagementProductPage extends StatefulWidget {
  const ManagementProductPage({Key? key}) : super(key: key);

  @override
  State<ManagementProductPage> createState() => _ManagementProductPageState();
}

class _ManagementProductPageState extends State<ManagementProductPage> {
  final homeModel = Get.put(HomeModelView());
  final findtext =TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homeModel.GetAllProduct();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: AnimSearchBar(
              width: MediaQuery.of(context).orientation ==
                  Orientation.portrait
                  ? 300
                  : 600,
              textController: findtext,
              onSuffixTap: () {},
              autoFocus: true,
              // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
              onSubmitted: (key) {
                homeModel.GetProductAdmin(findtext.text);
              },
            ),
          ),
        ],
        title: Text("Quản lý sản phẩm"),
      ),
      body: Obx(() => homeModel.list_product.length == 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: homeModel.list_product.length,
              itemBuilder: (context, index) {
                return ManagementProductWidget(homeModel.list_product[index],context);
              },
            )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (builder) => AddNewProductPage()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
