import 'package:flutter/material.dart';
import 'package:nieak/onlines/view_pages/admin/management_bill_page.dart';
import 'package:nieak/onlines/view_pages/admin/management_category_page.dart';
import 'package:nieak/onlines/view_pages/admin/management_message_page.dart';
import 'package:nieak/onlines/view_pages/admin/management_product_page.dart';
import 'package:nieak/onlines/view_pages/admin/management_user_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 3,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => ManagementUserPage()));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.green)),
                child: Center(
                  child: Align(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(
                            child: Icon(
                          Icons.manage_accounts,
                          size: 60,
                        )),
                        Center(
                            child: Text(
                          "Quản Lý Người Dùng",
                          textAlign: TextAlign.center,
                        ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => ManagementProductPage()));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.green)),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: Icon(
                        Icons.shop_outlined,
                        size: 60,
                      )),
                      Center(
                          child: Text(
                        "Quản Lý Sản Phẩm",
                        textAlign: TextAlign.center,
                      ))
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => ManagementBillPage()));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.green)),
                child: Center(
                  child: Align(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Center(
                            child: Icon(
                          Icons.shopping_cart_checkout,
                          size: 60,
                        )),
                        Center(
                            child: Text(
                          "Quản Lý Đơn Hàng",
                          textAlign: TextAlign.center,
                        ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => ManagementCategoryPage()));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.green)),
                child: Center(
                  child: Align(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Center(
                            child: Icon(
                          Icons.category,
                          size: 60,
                        )),
                        Center(
                            child: Text(
                          "Quản Lý Danh Mục",
                          textAlign: TextAlign.center,
                        ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => ManagementMessagepage()));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.green)),
                child: Center(
                  child: Align(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Center(
                            child: Icon(
                          Icons.messenger,
                          size: 60,
                        )),
                        Center(
                            child: Text(
                          "Tin Nhắn Người Dùng",
                          textAlign: TextAlign.center,
                        ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
