import 'dart:io';
import 'package:get/get.dart';
class AWSViewModel extends GetxController {
  Rx<File> vedioFile = File("").obs;
  var videoURL = "".obs;
  var fileURL = "".obs;
  Rx<File> jsonFile  = File('').obs;
}
