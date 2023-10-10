import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Toast {
  success({required massage}) {
    return Get.snackbar(
      "Success",
      massage,
      icon: const Icon(Icons.person, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      borderRadius: 20,
      margin: const EdgeInsets.all(15),
      colorText: Colors.white,
      duration: const Duration(milliseconds: 1500),
      isDismissible: true,
      forwardAnimationCurve: Curves.ease,
    );
  }

  error({required massage}) {
    return Get.snackbar(
      "Error",
      massage,
      icon: const Icon(Icons.person, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      borderRadius: 20,
      margin: const EdgeInsets.all(15),
      colorText: Colors.white,
      duration: Duration(milliseconds: 1500),
      isDismissible: true,
      forwardAnimationCurve: Curves.ease,
    );
  }
}
