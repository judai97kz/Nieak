import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nieak/onlines/mini_widget/comment_widget.dart';
import 'package:nieak/onlines/mini_widget/modal_action_info_product_page.dart';
import 'package:nieak/onlines/models/comment_model.dart';
import 'package:nieak/onlines/modelviews/cart_modelview.dart';
import 'package:nieak/onlines/modelviews/comment_modelview.dart';
import 'package:nieak/onlines/modelviews/home_modelview.dart';
import 'package:nieak/onlines/modelviews/user_state.dart';
import 'package:nieak/onlines/statepages/info_product_state.dart';
import 'package:nieak/onlines/statepages/management_state.dart';
import 'package:photo_view/photo_view.dart';

class InfoProductPage extends StatefulWidget {
  final Map<String, dynamic> shoe;
  const InfoProductPage({Key? key, required this.shoe}) : super(key: key);

  @override
  State<InfoProductPage> createState() => _InfoProductPageState();
}

class _InfoProductPageState extends State<InfoProductPage> {
  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
  final cartModel = Get.put(CartModelView());
  final modalAction = ActionModal();
  final ipState = Get.put(InfoProductState());
  final iduser = Get.put(UserState());
  final commentModel = Get.put(CommentModelView());
  final homeModel = Get.put(HomeModelView());
  final _commentController = TextEditingController();
  final managementState = Get.put(ManagementState());
  Future<void> _onRefresh() async {
    setState(() {
      print("Hello");
    });
  }

  void _handleSwipeBack(DragEndDetails details, BuildContext context) {
    if (details.primaryVelocity! > 0) {
      Navigator.pop(context);
    }
  }

  _showPhotoView(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
            appBar: AppBar(backgroundColor: Colors.black),
            body: GestureDetector(
              onVerticalDragEnd: (details) =>
                  _handleSwipeBack(details, context),
              child: Container(
                child: PhotoView(
                  imageProvider: NetworkImage(imageUrl),
                ),
              ),
            )),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ipState.size.value = widget.shoe['minsize'];

    commentModel.getAllComment(widget.shoe['idshoes']);
    commentModel.rate.value = double.parse(widget.shoe['rating'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                title: Text("Thông Tin Sản Phẩm"),
                actions: [
                  GestureDetector(
                    onTap: () {
                      managementState.currentindex.value = 1;
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(alignment: Alignment.center, children: [
                        const Align(
                          alignment: Alignment.center,
                          child: Icon(Icons.shopping_cart),
                        ),
                        Align(
                            alignment: Alignment.topRight,
                            child: Obx(
                              () => Padding(
                                padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                child: CircleAvatar(
                                  radius: 7,
                                  backgroundColor: Colors.red,
                                  child: Text(
                                    cartModel.list_cart.length.toString(),
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ),
                              ),
                            )),
                      ]),
                    ),
                  ),
                ],
              ),
              body: RefreshIndicator(
                onRefresh: _onRefresh,
                child: Stack(children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: CarouselSlider(
                                items: [
                                  for (int i = 0;
                                      i < widget.shoe['imagenumber'];
                                      i++)
                                    Container(
                                      child: GestureDetector(
                                        child: Stack(
                                          children: [
                                            Align(
                                                alignment: Alignment.center,
                                                child: Image.network(
                                                    widget.shoe["image"][i])),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 40, 5),
                                              child: Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: Color.fromRGBO(
                                                              157,
                                                              157,
                                                              157,
                                                              91)),
                                                      child: Text(
                                                          "  ${i + 1}/${widget.shoe['imagenumber']}  "))),
                                            )
                                          ],
                                        ),
                                        onTap: () {
                                          _showPhotoView(
                                              context, widget.shoe["image"][i]);
                                        },
                                      ),
                                    )
                                ],
                                options: CarouselOptions(
                                    autoPlay: true,
                                    enlargeCenterPage: true,
                                    enableInfiniteScroll: true)),
                          ),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Text(
                                    widget.shoe['nameshoes'],
                                    textAlign: TextAlign.left,
                                  ),
                                  width: 300,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Container(
                                      child: Text(
                                    "${myFormat.format(widget.shoe["price"])} đ",
                                    style: TextStyle(color: Colors.red),
                                  ))),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Obx(
                            () => Row(
                              children: [
                                RatingBar.builder(
                                  ignoreGestures: true,
                                  initialRating: commentModel.rate.value,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 20.0,
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                                Text("(${commentModel.rate.toString()}/5.0)")
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12)),
                          ),
                        ),
                        const Align(
                            child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Thông tin sản phẩm",
                            style: TextStyle(fontSize: 20),
                          ),
                        )),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  Text('Thương hiệu: ${widget.shoe["brand"]}'),
                            )),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                'Kích thước: ${widget.shoe["minsize"]} - ${widget.shoe["maxsize"]}'),
                          ),
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  'Số lượng trong kho: ${widget.shoe["amount"]}'),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12)),
                          ),
                        ),
                        const Text(
                          'Đánh giá sản phẩm',
                          style: TextStyle(fontSize: 20),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Obx(
                            () => RatingBar.builder(
                              ignoreGestures: false,
                              initialRating: ipState.rate.value,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 20.0,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                ipState.rate.value = rating;
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration:
                                const InputDecoration(hintText: "Bình Luận"),
                            controller: _commentController,
                            maxLines: null,
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              var date = DateTime.now();
                              var id = '${iduser.uidtemp.value}+${date}';
                              CommentModel newcmt = CommentModel(
                                  iduser: iduser.uidtemp.value,
                                  idcomment: id,
                                  username: iduser.user.value!.name,
                                  content: _commentController.text,
                                  idproduct: widget.shoe['idshoes'],
                                  datecomment: date.toString(),
                                  rating: ipState.rate.value);
                              commentModel.addComment(newcmt, context);
                              ipState.rate.value = 1;
                              _commentController.clear();
                            },
                            child: const Text("Bình luận")),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12)),
                          ),
                        ),
                        const Text("Đánh giá của người dùng",
                            style: TextStyle(fontSize: 20)),
                        const SizedBox(
                          height: 10,
                        ),
                        Obx(
                          () => Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              height:
                                  commentModel.list_cmt.length == 0 ? 50 : 400,
                              child: Obx(
                                () => commentModel.list_cmt.length == 0
                                    ? const Center(
                                        child: Text(
                                            "Chưa có bình luận cho sản phẩm"))
                                    : ListView.builder(
                                        itemCount: commentModel.list_cmt.length,
                                        itemBuilder: (context, index) {
                                          return CommentWidget(
                                            comment:
                                                commentModel.list_cmt[index],
                                          );
                                        }),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12)),
                          ),
                        ),
                        // Text('Sản Phẩm Cùng Hãng'),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Container(
                        //     height: 280,
                        //     child: ListView.builder(
                        //         scrollDirection: Axis.horizontal,
                        //         itemCount: homeModel.list_product.length,
                        //         itemBuilder: (context, index) {
                        //           return Padding(
                        //             padding: const EdgeInsets.all(3.0),
                        //             child: Container(
                        //               decoration: BoxDecoration(
                        //                   border:
                        //                       Border.all(color: Colors.black)),
                        //               width: 150,
                        //               child: GestureDetector(
                        //                 onTap: () async {
                        //                   Navigator.push(
                        //                       context,
                        //                       MaterialPageRoute(
                        //                           builder: (builder) =>
                        //                               InfoProductPage(
                        //                                   shoe: homeModel
                        //                                           .list_product[
                        //                                       index])));
                        //                 },
                        //                 child: MiniProduct(context,
                        //                     homeModel.list_product[index]),
                        //               ),
                        //             ),
                        //           );
                        //         }),
                        //   ),
                        // ),
                        const SizedBox(
                          height: 60,
                        )
                      ],
                    ),
                  ),
                ]),
              )),
          int.parse(widget.shoe["amount"].toString()) == 0
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 40,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Expanded(
                      child: Container(
                        height: 40,
                        color: Colors.red,
                        child: const Center(
                          child: Text(
                            "Không thể mua sản phẩm!",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 40,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              // await addValueToArray('image1', 'image', 'new_value');
                              // Map<String, dynamic>? mapValue = await getValueFromMapInArray('ádsad', 'cart', 0);
                              modalAction.InProductInfo(context, widget.shoe);
                            },
                            child: Container(
                              height: 40,
                              color: Colors.red,
                              child: const Center(
                                child: Text(
                                  "Thêm vào giỏ hàng",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                        ),
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            modalAction.BuyNow(context, widget.shoe);
                          },
                          child: Container(
                            height: 40,
                            color: Colors.green,
                            child: const Center(
                              child: Text(
                                "Mua Ngay",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
