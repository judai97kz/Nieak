import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nieak/onlines/mini_widget/product_widget.dart';
import 'package:nieak/onlines/modelviews/cart_modelview.dart';
import 'package:nieak/onlines/modelviews/user_state.dart';
import 'package:nieak/onlines/statepages/cart_state.dart';
import 'package:nieak/onlines/statepages/main_state.dart';
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
  final ScrollController _scrollController = ScrollController();
  final homeModel = Get.put(HomeModelView());
  final orientState = Get.put(OrientationController());
  final roleuser = Get.put(UserState());
  final findtext = TextEditingController();
  final cartState = Get.put(CartState());
  final cartModel = Get.put(CartModelView());
  final homeState = Get.put(HomeState());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homeModel.GetAllProduct();
    homeModel.GetAllBrand();
    homeModel.GetImageBanner();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels > 100 &&
          !homeState.showScrollButton.value) {
        homeState.showScrollButton.value = true;
      } else if (_scrollController.position.pixels <= 100 &&
          homeState.showScrollButton.value) {
        homeState.showScrollButton.value = false;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        int crossAxisCount = constraints.maxWidth ~/ 200;
        double itemWidth = constraints.maxWidth / crossAxisCount;
        return WillPopScope(
          onWillPop: () async {
            SystemNavigator.pop();
            return false;
          },
          child: Scaffold(
              resizeToAvoidBottomInset: true,
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
                        homeState.categoryState.value="All";
                        homeModel.GetProductTemp(findtext.text);
                      },
                    ),
                  ),
                ],
                title: const Text(
                  'NIEAK',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              body: Container(
                color: Color.fromRGBO(230, 230, 230, 0.3),
                child: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool isScrolled) {
                      return [
                        Obx(() => SliverAppBar(
                              backgroundColor: Colors.white,
                              automaticallyImplyLeading: false,
                              title: homeModel.list_banner.length == 0
                                  ? Center(child: CircularProgressIndicator())
                                  : CarouselSlider(
                                      options: CarouselOptions(
                                          autoPlay: true,
                                          enlargeCenterPage: true,
                                          enableInfiniteScroll: true),
                                      items: [
                                        for (int i = 0;
                                            i < homeModel.list_banner.length;
                                            i++)
                                          Stack(
                                            children: [
                                              Align(
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                    child: Image.network(
                                                      homeModel.list_banner[i],
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
                              toolbarHeight: 150,
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
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: homeModel.list_brand.length,
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                        onTap: () {
                                          if (homeModel.list_brand[index] ==
                                              'All') {
                                            homeModel.GetAllProduct();
                                          } else {
                                            homeModel.GetProductByBrand(
                                                homeModel.list_brand[index]);
                                          }
                                          homeState.categoryState.value=homeModel.list_brand[index];
                                        },
                                        child: Obx(()=>homeState.categoryState==homeModel.list_brand[index]?Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Container(
                                            width: 60,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.black),
                                                borderRadius:
                                                BorderRadius.circular(5),
                                                color: Colors.white),
                                            child: Center(
                                              child: Text(
                                                homeModel.list_brand[index],
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ): Padding(
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
                                                homeModel.list_brand[index],
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),)
                                      )),
                            )),
                        Obx(
                          () => homeModel.list_product.length == 0
                              ? homeModel.find_result == true
                                  ? Expanded(
                                      child: Center(
                                          child: Container(
                                      width: double.infinity,
                                      color: Colors.white,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/public/remove_shoes.jpg",
                                            height: 40,
                                          ),
                                          Text("Không có sản phẩm")
                                        ],
                                      ),
                                    )))
                                  : Expanded(
                                      child: Center(
                                          child: CircularProgressIndicator()))
                              : Expanded(
                                  child: Scrollbar(
                                    thickness: 8.0,
                                    radius: Radius.circular(8.0),
                                    child: GridView.builder(
                                      controller: _scrollController,
                                      itemCount: homeModel.list_product.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount:
                                                  MediaQuery.of(context)
                                                              .orientation ==
                                                          Orientation.portrait
                                                      ? 2
                                                      : 3,
                                              childAspectRatio:
                                                  MediaQuery.of(context)
                                                              .orientation ==
                                                          Orientation.portrait
                                                      ? itemWidth /
                                                          (itemWidth * 1.5)
                                                      : itemWidth /
                                                          (itemWidth * 1.2),
                                              crossAxisSpacing: 5,
                                              mainAxisSpacing: 5),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () async {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (builder) =>
                                                        InfoProductPage(
                                                            shoe: homeModel
                                                                    .list_product[
                                                                index])));
                                          },
                                          child: MiniProduct(context,
                                              homeModel.list_product[index]),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    )),
              ),
              floatingActionButton: Obx(() => homeState.showScrollButton == true
                  ? FloatingActionButton(
                      onPressed: () {
                        _scrollController.animateTo(
                          0.0,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Icon(Icons.arrow_upward),
                    )
                  : SizedBox.shrink())),
        );
      },
    );
  }
}
