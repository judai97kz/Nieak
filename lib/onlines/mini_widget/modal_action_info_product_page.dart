import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:nieak/onlines/modelviews/cart_modelview.dart';
import 'package:nieak/onlines/modelviews/user_state.dart';
import 'package:nieak/onlines/statepages/cart_state.dart';
import 'package:nieak/onlines/statepages/info_product_state.dart';
import 'package:nieak/onlines/view_pages/pay_page.dart';

class ActionModal {
  final ipState = Get.put(InfoProductState());
  final usertemp = Get.put(UserState());
  final cartState =Get.put(CartModelView());

  // Future<void> addMapToArray(String documentId, String fieldName,
  //     Map<String, dynamic> mapToAdd) async {
  //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //   final DocumentReference documentReference =
  //       _firestore.collection('user').doc(documentId);
  //   await documentReference.update({
  //     fieldName: FieldValue.arrayUnion([mapToAdd]),
  //   });
  // }

  Future<void> addOrUpdateMap(String documentId, String fieldName,
      Map<String, dynamic> mapToAdd) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final DocumentReference documentReference =
        _firestore.collection('user').doc(documentId);

    // Lấy dữ liệu hiện tại của tài liệu
    DocumentSnapshot docSnapshot = await documentReference.get();
    Map<String, dynamic> docData = docSnapshot.data() as Map<String, dynamic>;

    // Tìm kiếm mục dữ liệu bạn muốn kiểm tra và kiểm tra xem nó có phải là danh sách các Map không
    if (docData.containsKey(fieldName) && docData[fieldName] is List) {
      List<Map<String, dynamic>> mapList =
          List<Map<String, dynamic>>.from(docData[fieldName]);

      // Tìm map trong danh sách dựa trên thuộc tính nameproduct và size
      int existingMapIndex = mapList.indexWhere((element) =>
          element['nameproduct'] == mapToAdd['nameproduct'] &&
          element['size'] == mapToAdd['size']);

      if (existingMapIndex != -1) {
        // Nếu map tồn tại, cập nhật amount của mapToAdd cho map
        mapList[existingMapIndex]['amount'] = mapToAdd['amount'];

        // Cập nhật dữ liệu trong Firestore
        await documentReference.update({fieldName: mapList});
      } else {
        // Nếu map không tồn tại, thêm mapToAdd vào fieldName
        await documentReference.update({
          fieldName: FieldValue.arrayUnion([mapToAdd]),
        });
      }
    } else {
      throw Exception('Invalid data structure or missing key');
    }
  }

  void InProductInfo(BuildContext context, Map<String, dynamic> shoe) {
    var size;
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Obx(
            () => Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Size: ${ipState.size}")),
                    ),
                    SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: shoe['maxsize'] + 1 - shoe['minsize'],
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  size = index + shoe['minsize'];
                                  print(size);
                                  ipState.size.value = size;
                                },
                                // ignore: sort_child_properties_last
                                child: Text(
                                  "${index + shoe['minsize']}",
                                  style: const TextStyle(color: Colors.black),
                                ),
                                style: ButtonStyle(
                                    backgroundColor: index ==
                                            ipState.size.value - shoe['minsize']
                                        ? const MaterialStatePropertyAll<Color>(
                                            Colors.blue)
                                        : const MaterialStatePropertyAll<Color>(
                                            Colors.white)),
                              ),
                            );
                          }),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Số lượng")),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              ipState.disAmount();
                            },
                            child: const Text("-")),
                        Padding(
                          padding: const EdgeInsets.all(1.5),
                          child: Container(
                            width: 50,
                            height: 35,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: Center(
                              child: Text(
                                ipState.amount.toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              ipState.addAmout(shoe["amount"]);
                            },
                            child: const Text("+"))
                      ],
                    ),
                    Align(
                      child: ElevatedButton(
                        onPressed: () async {
                          Map<String, dynamic> mapToAdd = {
                            'sale':shoe['sale'],
                            'idshoes': shoe["idshoes"],
                            'nameproduct': shoe["nameshoes"],
                            'price': shoe["price"],
                            'image': shoe['image'][0],
                            'size': ipState.size.value,
                            'amount': ipState.amount.value,
                          };
                          await addOrUpdateMap(
                              usertemp.uidtemp.toString(), 'cart', mapToAdd);
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Thêm Sản Phẩm Thành Công!')));
                          cartState.getAllMapsInArray( usertemp.uidtemp.toString());
                        },
                        child: const Text("Thêm"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void BuyNow(BuildContext context, Map<String, dynamic> shoe) {
    var size;
    final cartState = Get.put(CartState());
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Obx(
                () => Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Size: ${ipState.size}")),
                    ),
                    SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: shoe['maxsize'] + 1 - shoe['minsize'],
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  size = index + shoe['minsize'];
                                  print(size);
                                  ipState.size.value = size;
                                },
                                // ignore: sort_child_properties_last
                                child: Text(
                                  "${index + shoe['minsize']}",
                                  style: const TextStyle(color: Colors.black),
                                ),
                                style: ButtonStyle(
                                    backgroundColor: index ==
                                        ipState.size.value - shoe['minsize']
                                        ? const MaterialStatePropertyAll<Color>(
                                        Colors.blue)
                                        : const MaterialStatePropertyAll<Color>(
                                        Colors.white)),
                              ),
                            );
                          }),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Số lượng")),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              ipState.disAmount();
                            },
                            child: const Text("-")),
                        Padding(
                          padding: const EdgeInsets.all(1.5),
                          child: Container(
                            width: 50,
                            height: 35,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: Center(
                              child: Text(
                                ipState.amount.toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              ipState.addAmout(shoe["amount"]);
                            },
                            child: const Text("+"))
                      ],
                    ),
                    Align(
                      child: ElevatedButton(
                        onPressed: () async {
                          Map<String, dynamic> mapToAdd = {
                            'sale':shoe['sale'],
                            'idshoes': shoe["idshoes"],
                            'nameproduct': shoe["nameshoes"],
                            'price': shoe["price"],
                            'image': shoe['image'][0],
                            'size': ipState.size.value,
                            'amount': ipState.amount.value,
                          };
                          cartState.list_temp.value=[];
                          cartState.list_temp.add(mapToAdd);
                          Navigator.of(context).pop();
                          Navigator.push(context, MaterialPageRoute(builder: (builder)=>PayPage()));

                        },
                        child: const Text("Thêm"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
