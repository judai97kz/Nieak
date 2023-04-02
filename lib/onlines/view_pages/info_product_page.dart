import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nieak/onlines/modelviews/cart_modelview.dart';
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
          body:GestureDetector(
            onVerticalDragEnd: (details) => _handleSwipeBack(details, context),
            child:  Container(
              child: PhotoView(
                imageProvider: NetworkImage(imageUrl),
              ),
            ),
          )
        ),
      ),
    );
  }

  Future<void> addValueToArray(String documentId, String fieldName, dynamic value) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final DocumentReference documentReference = _firestore.collection('imagebanner').doc(documentId);
    await documentReference.update({
      fieldName: FieldValue.arrayUnion([value]),
    });
  }

  Future<Map<String, dynamic>?> getValueFromMapInArray(String documentId, String arrayFieldName, int mapIndex) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final DocumentReference documentReference = _firestore.collection('user').doc(documentId);

    DocumentSnapshot documentSnapshot = await documentReference.get();
    List<dynamic> arrayField = documentSnapshot[arrayFieldName];

    if (arrayField == null || arrayField.isEmpty || arrayField.length <= mapIndex || !(arrayField[mapIndex] is Map)) {
      return null;
    }
    print(arrayField[mapIndex]);
    return arrayField[mapIndex] as Map<String, dynamic>;
  }


  Future<void> addMapToArray(String documentId, String fieldName, Map<String, dynamic> mapToAdd) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final DocumentReference documentReference = _firestore.collection('user').doc(documentId);
    await documentReference.update({
      fieldName: FieldValue.arrayUnion([mapToAdd]),
    });
  }

  Future<int> getArrayLength(String documentId, String arrayFieldName) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final DocumentReference documentReference = _firestore.collection('your_collection_name').doc(documentId);

    DocumentSnapshot documentSnapshot = await documentReference.get();
    List<dynamic> arrayField = documentSnapshot[arrayFieldName];

    if (arrayField == null) {
      return 0;
    }

    return arrayField.length;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: Stack(children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: CarouselSlider(
                        items: [
                          for (int i = 0; i < widget.shoe['imagenumber']; i++)
                            Container(
                              child: GestureDetector(
                                child: Stack(
                                  children: [
                                    Align(
                                        alignment: Alignment.center,
                                        child: Image.network(
                                            widget.shoe["image"][i])),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 25, 5),
                                      child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Color.fromRGBO(
                                                      157, 157, 157, 91)),
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
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 40,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap:() async {
                          // await addValueToArray('image1', 'image', 'new_value');
                          // Map<String, dynamic>? mapValue = await getValueFromMapInArray('ádsad', 'cart', 0);
                          // Map<String, dynamic> mapToAdd = {
                          //   'nameproduct': 'value1',
                          //   'gia': 200,
                          //   'soluong': 2,
                          // };
                          // await addMapToArray('ádsad', 'cart', mapToAdd);
                          cartModel.getAllMapsInArray('ádsad', 'cart');
                        },
                        child: Container(
                          height: 40,
                          color: Colors.red,
                          child: Center(
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
                        child: Container(
                          height: 40,
                          color: Colors.green,
                          child: Center(
                            child: Text(
                      "Mua Ngay",
                      textAlign: TextAlign.center,
                    ),
                          ),
                        ))
                  ],
                ),
              ),
            )
          ]),
        ));
  }
}
