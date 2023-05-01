import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nieak/onlines/modelviews/home_modelview.dart';
import 'package:nieak/onlines/statepages/add_new_product_state.dart';

class AddNewProductPage extends StatefulWidget {
  const AddNewProductPage({Key? key}) : super(key: key);
  @override
  State<AddNewProductPage> createState() => _AddNewProductPageState();
}

class _AddNewProductPageState extends State<AddNewProductPage> {
  PlatformFile? pickedFile;
  List<File> files = [];

  List<String> ListUrl = [];
  final homestate = Get.put(HomeModelView());
  final addState = Get.put(AddNewProductState());
  final _idshoes = TextEditingController();
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

  Future uploadFile() async {}

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
        appBar: AppBar(
          title: Text("Thêm Sản Phẩm Mới"),
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
                      ? Image.network("https://firebasestorage.googleapis.com/v0/b/nieak-cc562.appspot.com/o/errorimage%2FnoImage.png?alt=media&token=ada38ac7-8f4d-4f26-a6fd-8cd24e7e660c")
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
                    controller: _idshoes,
                    decoration: InputDecoration(
                        labelText: "Mã sản phẩm",
                        errorText: addState.idtext.value == ""
                            ? null
                            : addState.idtext.value),
                  ),
                ),
              ), //Ma sp
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
              Obx(
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
                    addState.checkNull(
                        _idshoes.text,
                        _nameshoes.text,
                        addState.defaulValue.value,
                        _priceshoes.text,
                        _minshoes.text,
                        _maxshoes.text,
                        _amoutshoes.text,
                        _colorshoes.text,
                        files,context );
                  },
                  child: Text("Thêm sản phẩm"))
            ],
          ),
        ),
      ),
    );
  }
}
