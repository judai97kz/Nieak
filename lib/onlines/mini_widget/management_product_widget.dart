import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nieak/onlines/modelviews/home_modelview.dart';
import 'package:nieak/onlines/view_pages/admin/edit_product_page.dart';

Widget ManagementProductWidget(
    Map<String, dynamic> product, BuildContext context) {
  Future<void> updateSale(String targetId, int newSale) async {
    // Lấy tham chiếu đến Firestore
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Truy vấn các documents có thuộc tính 'cart'
    QuerySnapshot querySnapshot = await firestore
        .collection('user')
        .where('cart', isNotEqualTo: null)
        .get();

    // Duyệt qua các documents
    for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
      List<dynamic> cartItems = documentSnapshot['cart'];
      bool updateNeeded = false;
      for (Map<String, dynamic> item in cartItems) {
        if (item['idshoes'] == targetId) {
          // Cập nhật giá trị 'sale' cho Map có thuộc tính 'id' mong muốn
          item['sale'] = newSale;
          updateNeeded = true;
        }
      }
      if (updateNeeded) {
        await firestore
            .collection('user')
            .doc(documentSnapshot.id)
            .update({'cart': cartItems});
      }
    }
  }

  final homeModel = Get.put(HomeModelView());
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Column(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text('Mã sản phẩm: ${product['idshoes']}'),
              )),
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text('Tên sản phẩm: ${product['nameshoes']}'),
              )),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.network(
                    product['image'][0],
                    height: 60,
                    width: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Kích thước: ${product['minsize']}-${product['maxsize']}'),
                        Text('Đơn giá: ${product['price']}'),
                        Text('Số lượng: ${product['amount']}')
                      ],
                    ),
                  ),
                  Expanded(
                    child: OverflowBar(
                      children: [
                        Text("Khuyến mãi (%): "),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                if (product['sale'] > 0) {
                                  await FirebaseFirestore.instance
                                      .collection('product')
                                      .doc(product['idshoes'].toString())
                                      .update({'sale': product['sale'] - 1});
                                  homeModel.GetAllProduct();
                                }
                              },
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                child: Center(child: Text("-")),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Text(product['sale'].toString()),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (product['sale'] < 100) {
                                  var sum = product['sale'] + 1;
                                  await FirebaseFirestore.instance
                                      .collection('product')
                                      .doc(product['idshoes'].toString())
                                      .update({'sale': sum});
                                  updateSale(product['idshoes'], sum);
                                  homeModel.GetAllProduct();
                                }
                              },
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                child: Center(child: Text("+")),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) =>
                                EditProductPage(product: product)));
                  },
                  child: Container(
                    height: 25,
                    color: Colors.red,
                    child: Center(child: Text("Sửa")),
                  ),
                )),
                Expanded(
                    child: GestureDetector(
                  onTap: () async {
                    AlertDialog dialog = AlertDialog(
                      title: Text("Thông Báo"),
                      content: Text("Bạn có muốn xóa sản phẩm?"),
                      actions: [
                        ElevatedButton(
                            onPressed: () async {
                              final querySnapshot = await FirebaseFirestore
                                  .instance
                                  .collection('product')
                                  .where('idshoes',
                                      isEqualTo: product['idshoes'])
                                  .get();
                              final docsList = querySnapshot.docs;
                              for (final doc in docsList) {
                                await doc.reference.delete();
                              }
                              final FirebaseStorage storage =
                                  FirebaseStorage.instance;
                              final Reference parentFolderRef = storage
                                  .ref()
                                  .child('/Products/${product['idshoes']}');

                              parentFolderRef.listAll().then((result) {
                                // Xóa toàn bộ các tệp tin và thư mục con bên trong thư mục parentFolder
                                result.items.forEach((Reference ref) {
                                  ref.delete().then((value) {
                                    print('Đã xóa ${ref.name}.');
                                  }).catchError((error) {
                                    print(
                                        'Đã xảy ra lỗi khi xóa ${ref.name}: $error');
                                  });
                                });
                                // Xóa thư mục parentFolder
                                parentFolderRef
                                    .delete()
                                    .then((value) {})
                                    .catchError((error) {
                                  print(
                                      'Đã xảy ra lỗi khi xóa thư mục parentFolder: $error');
                                });
                              }).catchError((error) {
                                print(
                                    'Đã xảy ra lỗi khi liệt kê các tệp tin và thư mục con trong parentFolder: $error');
                              });
                              homeModel.GetAllProduct();
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Đã xóa sản phẩm")));
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
                  child: Container(
                    height: 25,
                    color: Colors.green,
                    child: Center(child: Text("Xóa")),
                  ),
                ))
              ],
            ),
          )
        ],
      ),
    ),
  );
}
