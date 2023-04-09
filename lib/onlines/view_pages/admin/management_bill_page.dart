import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:nieak/onlines/mini_widget/management_bill_widget.dart';
import 'package:nieak/onlines/modelviews/bill_modelview.dart';

class ManagementBillPage extends StatefulWidget {
  const ManagementBillPage({Key? key}) : super(key: key);

  @override
  State<ManagementBillPage> createState() => _ManagementBillPageState();
}

class _ManagementBillPageState extends State<ManagementBillPage> {
  final billModel = Get.put(BillModelView());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    billModel.getAllBill();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => billModel.list_bill_admin.length == 0
          ? CircularProgressIndicator()
          : ListView.builder(
              itemCount: billModel.list_bill_admin.length,
              itemBuilder: (context, index) {
                return ManagementBillWidget(context, billModel.list_bill_admin[index]);
              },
            )),
    );
  }
}
