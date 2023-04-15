import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nieak/onlines/modelviews/home_modelview.dart';
import 'package:nieak/onlines/statepages/add_new_product_state.dart';

class EditProductPage extends StatefulWidget {
  final product;
  const EditProductPage({Key? key, required this.product}) : super(key: key);
  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  PlatformFile? pickedFile;
  List<File> files = [];

  final homestate = Get.put(HomeModelView());
  final addState = Get.put(AddNewProductState());
  final _nameshoes = TextEditingController();
  final _priceshoes = TextEditingController();
  final _amoutshoes = TextEditingController();
  final _minshoes = TextEditingController();
  final _maxshoes = TextEditingController();
  final _colorshoes = TextEditingController();

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    if (result == null) return;
    setState(() {
      files = result.paths.map((path) => File(path!)).toList();
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameshoes.text = widget.product['nameshoes'];
    addState.defaulValue.value = widget.product['brand'];
    _priceshoes.text = widget.product['price'].toString();
    _minshoes.text = widget.product['minsize'].toString();
    _maxshoes.text = widget.product['maxsize'].toString();
    _amoutshoes.text = widget.product['amount'].toString();
    _colorshoes.text = widget.product['color'];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        files = [];
        addState.ListUrl.value = [];
        addState.defaulValue.value = "";
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text("Sửa Thông Tin Sản Phẩm"),
          leading: BackButton(
            onPressed: () {
              files = [];
              addState.ListUrl.value = [];
              addState.defaulValue.value = "";
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(

          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: files.length == 0
                      ? SizedBox(
                          height: 250,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: widget.product['imagenumber'],
                              itemBuilder: (context, index) => Container(
                                  height: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.network(
                                        widget.product['image'][index]),
                                  ))),
                        )
                      : Container(
                          height: 250,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: files.length,
                              itemBuilder: (context, index) => Container(
                                  height: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.file(files[index]),
                                  ))),
                        ),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    selectFile();
                  },
                  child: Text("Chọn Ảnh")),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _nameshoes,
                    decoration: InputDecoration(
                        labelText: "Tên sản phẩm",
                        errorText: addState.nametext.value == ""
                            ? null
                            : addState.nametext.value),
                  ),
                ),
              ), //ten sp
              Container(
                child: Obx(
                  () => homestate.list_brand.length == 0
                      ? Text("------")
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: double.infinity,
                            child: DropdownButton(
                              isExpanded: true,
                              value: addState.defaulValue.value,
                              items: [
                                DropdownMenuItem(
                                    value: "", child: Text("Chọn thương hiệu")),
                                for (int i = 0;
                                    i < homestate.list_brand.length;
                                    i++)
                                  if (homestate.list_brand[i] != 'All')
                                    DropdownMenuItem(
                                        value: homestate.list_brand[i],
                                        child: Text(homestate.list_brand[i]))
                              ],
                              onChanged: (newValue) {
                                addState.defaulValue.value =
                                    newValue.toString();
                              },
                            ),
                          ),
                        ),
                ),
              ),
              Obx(() => addState.brandtext.value == ""
                  ? SizedBox(
                      height: 0,
                    )
                  : Text(addState.brandtext.value)), //hang
              Obx(
                () => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      controller: _priceshoes,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Giá sản phẩm",
                          errorText: addState.pricetext.value == ""
                              ? null
                              : addState.pricetext.value)),
                ),
              ), //gia
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: _minshoes,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Kích thước tối thiểu",
                        errorText: addState.mintext.value == ""
                            ? null
                            : addState.mintext.value)),
              ), //min
              Obx(
                () => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      controller: _maxshoes,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Kích thước tối đa",
                          errorText: addState.maxtext.value == ""
                              ? null
                              : addState.maxtext.value)),
                ),
              ), //max
              Obx(
                () => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      controller: _amoutshoes,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Số lượng",
                          errorText: addState.amounttext.value == ""
                              ? null
                              : addState.amounttext.value)),
                ),
              ), //solg
              Obx(
                () => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      controller: _colorshoes,
                      decoration: InputDecoration(
                          labelText: "Màu",
                          errorText: addState.colortext.value == ""
                              ? null
                              : addState.colortext.value)),
                ),
              ), //mau
              ElevatedButton(
                  onPressed: () async {
                    print(widget.product['image']);
                    addState.updateData(
                        widget.product['idshoes'],
                        _nameshoes.text,
                        addState.defaulValue.value,
                        _priceshoes.text,
                        _minshoes.text,
                        _maxshoes.text,
                        _amoutshoes.text,
                        _colorshoes.text,
                        files,
                        context,
                      widget.product['image']
                    );
                    homestate.GetAllProduct();
                  },
                  child: Text("Cập nhật thông tin"))
            ],
          ),
        ),
      ),
    );
  }
}
