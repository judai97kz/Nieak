import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class BillModelView extends GetxController {
  var list_bill = [].obs;
  var list_bill_admin = [].obs;
  getBillUser(String iduser) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('bill')
        .where('iduser', isEqualTo: iduser).where('cancel', isEqualTo:false)
        .get();
    list_bill.value = querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  getAllBill() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('bill').get();
    list_bill_admin.value =
        querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  updateAcceptState(String id) {
    FirebaseFirestore.instance
        .collection('bill')
        .doc(id)
        .update({'acceptstate': true});
    getAllBill();
  }

  updateReveiceState(String id, String iduser) {
    FirebaseFirestore.instance
        .collection('bill')
        .doc(id)
        .update({'receivestate': true});
    getAllBill();
    getBillUser(iduser);
  }

  deleteBill(String id, String iduser) {
    FirebaseFirestore.instance.collection('bill').doc(id).update({'cancel':true});
    getBillUser(iduser);
  }

  generatePdf(Map<String, dynamic> bill,BuildContext context) async {
    int contentLength = bill['content'].length;
    final fontData = await rootBundle.load("assets/fonts/OpenSans-Regular.ttf");
    final ttf = await Font.ttf(fontData);
    final pdf = pw.Document();
    NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
    bill['content'].map((data) => print(data));
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
              child: pw.Column(children: [
            pw.Padding(
                padding: pw.EdgeInsets.all(3.0),
                child: pw.Text('HÓA ĐƠN MUA HÀNG CỦA CỬA HÀNG NIEAK',
                    style: pw.TextStyle(font: ttf,fontSize: 25,fontBold: Font.courierBold()),textAlign: TextAlign.center)),
            pw.Padding(
                padding: pw.EdgeInsets.all(3.0),
                child: pw.Text('Mã hóa đơn: ${bill["idbill"]}',
                    style: pw.TextStyle(font: ttf))),
            pw.Container(
                decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black))),
            pw.Text('Sản phẩm đã mua:', style: pw.TextStyle(font: ttf)),
            pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black),
                defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                children: [
                  pw.TableRow(
                      verticalAlignment: pw.TableCellVerticalAlignment.middle,
                      children: [
                        pw.Padding(
                            padding: pw.EdgeInsets.all(3.0),
                            child: pw.Center(
                                child: pw.Text("STT",
                                    style: pw.TextStyle(font: ttf, fontSize: 8)))),
                        pw.Padding(
                            padding: pw.EdgeInsets.all(3.0),
                            child: pw.Center(
                                child: pw.Text("Tên Sản Phẩm",
                                    style: pw.TextStyle(font: ttf, fontSize: 8)))),
                        pw.Padding(
                            padding: pw.EdgeInsets.all(3.0),
                            child: pw.Center(
                                child: pw.Text("Size",
                                    style: pw.TextStyle(font: ttf, fontSize: 8)))),
                        pw.Padding(
                            padding: pw.EdgeInsets.all(3.0),
                            child: pw.Center(
                                child: pw.Text("Số lượng",
                                    style: pw.TextStyle(font: ttf, fontSize: 8)))),
                        pw.Padding(
                            padding: pw.EdgeInsets.all(3.0),
                            child: pw.Center(
                                child: pw.Text("Đơn giá",
                                    style: pw.TextStyle(font: ttf, fontSize: 8)))),
                      ]),
                  for (int i = 0; i < contentLength; i++)
                    pw.TableRow(children: [
                      pw.Padding(
                          padding: pw.EdgeInsets.all(3.0),
                          child: pw.Center(
                              child: pw.Text("${i + 1}",
                                  style: pw.TextStyle(font: ttf, fontSize: 9)))),
                      pw.Padding(
                          padding: pw.EdgeInsets.all(3.0),
                          child: pw.Center(
                              child: pw.Text(bill['content'][i]['nameproduct'],
                                  style: pw.TextStyle(font: ttf, fontSize: 9)))),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(3.0),
                        child: pw.Center(
                            child: pw.Text(
                                bill['content'][i]['size'].toString(),
                                style: pw.TextStyle(font: ttf, fontSize: 9))),
                      ),
                      pw.Padding(
                          padding: pw.EdgeInsets.all(3.0),
                          child: pw.Center(
                            child: pw.Text(
                                bill['content'][i]['amount'].toString(),
                                style: pw.TextStyle(font: ttf, fontSize: 9)),
                          )),
                      pw.Padding(
                          padding: pw.EdgeInsets.all(3.0),
                          child: pw.Center(
                            child: pw.Text(
                                "${myFormat.format(bill['content'][i]['price'])}đ",
                                style: pw.TextStyle(font: ttf, fontSize: 9)),
                          ))
                    ]),
                ]),
            pw.Padding(
                padding: pw.EdgeInsets.all(3.0),
                child: pw.Center(
                  child: pw.Text("Tổng: ${myFormat.format(bill['allprice'])}đ",
                      style: pw.TextStyle(font: ttf, fontSize: 9)),
                )),
            pw.Container(
                decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black))),
            pw.Text('Thông Tin Người Nhận', style: pw.TextStyle(font: ttf)),
            pw.Container(
              width: 200,
              child: pw.Table(children: [
                pw.TableRow(children: [
                  pw.Padding(
                      padding: pw.EdgeInsets.all(3.0),
                      child: pw.Center(
                          child: pw.Text("Tên Người Nhận:",
                              style: pw.TextStyle(font: ttf, fontSize: 12)))),
                  pw.Padding(
                      padding: pw.EdgeInsets.all(3.0),
                      child: pw.Center(
                          child: pw.Text(bill["username"],
                              style: pw.TextStyle(font: ttf, fontSize: 12)))),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                      padding: pw.EdgeInsets.all(3.0),
                      child: pw.Center(
                          child: pw.Text("Số điện thoại:",
                              style: pw.TextStyle(font: ttf, fontSize: 12)))),
                  pw.Padding(
                      padding: pw.EdgeInsets.all(3.0),
                      child: pw.Center(
                          child: pw.Text(bill["userphone"],
                              style: pw.TextStyle(font: ttf, fontSize: 12)))),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                      padding: pw.EdgeInsets.all(3.0),
                      child: pw.Center(
                          child: pw.Text("Địa chỉ:",
                              style: pw.TextStyle(font: ttf, fontSize: 12)))),
                  pw.Padding(
                      padding: pw.EdgeInsets.all(3.0),
                      child: pw.Center(
                          child: pw.Text(bill["addressreceive"],
                              style: pw.TextStyle(font: ttf, fontSize: 12)))),
                ]),
              ]),
            ),
            pw.Container(
                decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black))),
            pw.Text(
                'Cảm Ơn Quý Khách Đã Mua Hàng Tại Nieak! Nếu Có Vấn Đề Gì Không Hài Lòng Xin Quý Khách Liên Hệ Với Số : 0367989659 Để Nhận Tư Vấn !',
                style: pw.TextStyle(font: ttf)),
          ])); // Thêm đoạn văn bản vào trung tâm trang
        }));

    Directory? directory = await getExternalStorageDirectory();
    String path = directory!.path;
    print(path);
    final file = File("${path}/${bill['idbill']}.pdf");
    await file.writeAsBytes(await pdf.save());

  }
}
