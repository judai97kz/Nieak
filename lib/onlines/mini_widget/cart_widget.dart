import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nieak/onlines/modelviews/cart_modelview.dart';
import 'package:nieak/onlines/modelviews/user_state.dart';

Widget CartWidget(BuildContext context, Map<String, dynamic> product,int index) {
  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
  final cartModel = Get.put(CartModelView());
  final uidtemp = Get.put(UserState());
  return Padding(
    padding: const EdgeInsets.all(0.0),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 120,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                    decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Image.network(
                      product["image"],
                      height: 90,
                      width: 90,
                    )),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            product["nameproduct"],
                            style: TextStyle(color: Colors.red,fontSize: 13),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Text("Kích thước: ${product["size"]}"),
                      product["sale"]==0? Text("Đơn giá: ${myFormat.format(product["price"])}"):Text("Đơn giá: ${myFormat.format(product["price"])}đ",style: TextStyle(decoration: TextDecoration.lineThrough),),
                      product["sale"]==0?SizedBox(height: 0,):Text("Khuyến mãi: ${myFormat.format(product["price"]*(100-product["sale"])/100)}đ",style: TextStyle(color: Colors.red),),
                      Text("Số lượng: ${product["amount"]}"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 8, 0),
              child: GestureDetector(onTap: (){
                cartModel.deleteProductFromCart(uidtemp.uidtemp.toString(), index);
              },child: Icon(Icons.remove_circle,color: Colors.red,),),
            ))
      ],
    )
  );
}

