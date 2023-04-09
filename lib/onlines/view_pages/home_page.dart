import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nieak/onlines/mini_widget/product_widget.dart';
import 'package:nieak/onlines/modelviews/user_state.dart';
import 'package:nieak/onlines/statepages/orient_state.dart';
import 'package:nieak/onlines/view_pages/info_product_page.dart';

import '../modelviews/home_modelview.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final homeState = Get.put(HomeModelView());
  final orientState = Get.put(OrientationController());
  final roleuser = Get.put(UserState());
  final findtext = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homeState.GetAllProduct();
    homeState.GetAllBrand();
    homeState.GetImageBanner();
    // print(roleuser.user.value!.name);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Container(
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
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
                      homeState.GetProductTemp(findtext.text);
                    },
                  ),
                ),
              ],
              title: Text("NIEAK"),
            ),
            body: Container(
              color: Colors.grey,
              child: NestedScrollView(
                  headerSliverBuilder: (BuildContext context, bool isScrolled) {
                    return [
                      Obx(() => SliverAppBar(
                            backgroundColor: Colors.white,
                            automaticallyImplyLeading: false,
                            title: homeState.list_banner.length == 0
                                ? Center(child: CircularProgressIndicator())
                                : CarouselSlider(
                                    options: CarouselOptions(
                                        autoPlay: true,
                                        enlargeCenterPage: true,
                                        enableInfiniteScroll: true),
                                    items: [
                                      for (int i = 0;
                                          i < homeState.list_banner.length;
                                          i++)
                                        Stack(
                                          children: [
                                            Align(
                                                alignment: Alignment.center,
                                                child: Container(
                                                  child: Image.network(
                                                    homeState.list_banner[i],
                                                    loadingBuilder: (context,
                                                        child,
                                                        loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) return child;
                                                      return Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    },
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return Center(
                                                        child:
                                                            Icon(Icons.error),
                                                      );
                                                    },
                                                  ),
                                                )),
                                          ],
                                        )
                                    ],
                                  ),
                            toolbarHeight: 200,
                          ))
                    ];
                  },
                  body: Column(
                    children: [
                      Container(
                          height: 40,
                          width: double.infinity,
                          // ignore: avoid_unnecessary_containers
                          child: Obx(
                            () => ListView.builder(
                                // controller: _scrollController,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: homeState.list_brand.length,
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                      onTap: () {
                                        if (homeState.list_brand[index] ==
                                            'All') {
                                          homeState.GetAllProduct();
                                        } else {
                                          homeState.GetProductByBrand(
                                              homeState.list_brand[index]);
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Container(
                                          width: 60,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.blue),
                                          child: Center(
                                            child: Text(
                                              homeState.list_brand[index],
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )),
                          )),
                      Obx(
                        () => homeState.list_product.length == 0
                            ? Expanded(
                                child:
                                    Center(child: CircularProgressIndicator()))
                            : Expanded(
                                child: GridView.builder(
                                  itemCount: homeState.list_product.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 7 / 10,
                                    crossAxisSpacing: 0.0,
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (builder) =>
                                                    InfoProductPage(
                                                        shoe: homeState
                                                                .list_product[
                                                            index])));
                                      },
                                      child: MiniProduct(context,
                                          homeState.list_product[index]),
                                    );
                                  },
                                ),
                              ),
                      ),
                    ],
                  )),
            )),
      ),
    );
  }
}
