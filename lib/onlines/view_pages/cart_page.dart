import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nieak/onlines/mini_widget/cart_widget.dart';
import 'package:nieak/onlines/modelviews/cart_modelview.dart';
import 'package:nieak/onlines/modelviews/user_state.dart';
import 'package:nieak/onlines/statepages/cart_state.dart';
import 'package:nieak/onlines/statepages/management_state.dart';
import 'package:nieak/onlines/view_pages/management_page.dart';
import 'package:nieak/onlines/view_pages/pay_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final cartModel = Get.put(CartModelView());
  final uidtemp = Get.put(UserState());
  final listCheck = Get.put(CartState());
  List<Map<String, dynamic>> list_temp = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cartModel.getAllMapsInArray(uidtemp.user.value!.id);
    listCheck.createList(cartModel.list_cart.length);
    listCheck.checkTrue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Giỏ Hàng"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Obx(() => cartModel.list_cart.length == 0
                          ? Center(
                              child: Text(
                                  "Không có sản phẩm nào trong giỏ hàng của bạn"),
                            )
                          : ListView.builder(
                              itemCount: cartModel.list_cart.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                final reversedIndex =
                                    cartModel.list_cart.length - 1 - index;
                                return CheckboxListTile(
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title: CartWidget(
                                        context,
                                        cartModel.list_cart[reversedIndex],
                                        reversedIndex),
                                    dense: true,
                                    value: listCheck.list_check[reversedIndex],
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (listCheck
                                                .list_check[reversedIndex] ==
                                            false) {
                                          listCheck.list_check[reversedIndex] =
                                              true;
                                        } else {
                                          listCheck.list_check[reversedIndex] =
                                              false;
                                        }
                                        listCheck.checkTrue();
                                      });
                                    });
                              })),
                    ),
                    SizedBox(
                      height: 40,
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Obx(
                    () => listCheck.buttonState == false
                        ? SizedBox(
                            height: 0,
                          )
                        : GestureDetector(
                            onTap: () {
                              for (int i = 0;
                                  i < listCheck.list_check.length;
                                  i++) {
                                if (listCheck.list_check[i] == true) {
                                  list_temp.add(cartModel.list_cart[i]);
                                }
                              }
                              listCheck.list_temp.value = list_temp;
                              list_temp = [];
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => PayPage()));
                            },
                            child: Container(
                              color: Colors.deepOrangeAccent,
                              width: double.infinity,
                              height: 40,
                              child: Center(child: Text("Thanh Toán")),
                            ),
                          ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
