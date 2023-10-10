// ignore_for_file: non_constant_identifier_names
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:simple_s3/simple_s3.dart';
import '../../Utils/Toast.dart';
SimpleS3 _simpleS3 = SimpleS3();
SimpleS3 _simpleS3forjsonFile= SimpleS3();
Future<String?> upload_AWS_S3({
  required File filePath,
  required BuildContext context,
  bool isVideo = false,
}) async {
  String? result;
  if (result == null) {
    try {
      result = await _simpleS3.uploadFile(
        filePath,
        'starbazaarpublicbucket',
        'us-east-1:17c82b10-ced5-408f-96f0-4db8e04a3f0e',
        AWSRegions.usEast1,
        debugLog: true,
        accessControl: S3AccessControl.publicReadWrite,
      );
      if (isVideo) {
        Toast().success(massage: "Video Uploaded Successfully");
      } else {
        Toast().success(massage: "Image Uploaded Successfully");
      }

      return result;
    } catch (e) {
      Toast().error(massage: e.toString());
    }
  }
  return null;
}
Future<String?> upload_AWS_S3Json({
  required BuildContext context,
  required File file,
  bool isFile=false,
}) async {
  String? result;
  if (result == null) {
    try {
      result = await _simpleS3forjsonFile.uploadFile(
        file,
        'starbazaarpublicbucket',
        'us-east-1:17c82b10-ced5-408f-96f0-4db8e04a3f0e',
        AWSRegions.usEast1,
        debugLog: true,
        accessControl: S3AccessControl.publicReadWrite,
      );
      if (isFile) {
        Toast().success(massage: " File Uploaded Successfully");
      } else {
        Toast().success(massage: "Image Uploaded Successfully");
      }return result;
    } catch (e) {
      Toast().error(massage: e.toString());
    }
  }
  return null;
}

