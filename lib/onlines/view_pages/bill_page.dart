import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:nieak/onlines/mini_widget/bill_widget.dart';
import 'package:nieak/onlines/modelviews/bill_modelview.dart';
import 'package:nieak/onlines/modelviews/user_state.dart';

class BillPage extends StatefulWidget {
  const BillPage({Key? key}) : super(key: key);

  @override
  State<BillPage> createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  final billModel = Get.put(BillModelView());
  final userInfor = Get.put(UserState());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    billModel.getBillUser(userInfor.uidtemp.value);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(()=>billModel.list_bill.length==0?CircularProgressIndicator():ListView.builder(
        itemCount: billModel.list_bill.length,
        itemBuilder: (context,index){
          return BillWidget(context, billModel.list_bill[index]);
        },
      )),
    );
  }
}
