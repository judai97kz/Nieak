import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrientationController extends GetxController with WidgetsBindingObserver {
  var orientation = "".obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final Orientation newOrientation = MediaQuery.of(Get.context!).orientation;
    if (newOrientation != orientation.value) {
      orientation.value = newOrientation.toString();
    }
  }
}
