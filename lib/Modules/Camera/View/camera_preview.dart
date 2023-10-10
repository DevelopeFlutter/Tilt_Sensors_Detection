import 'package:flutter/material.dart';

class CameraPreview extends StatefulWidget {
  const CameraPreview({Key? key}) : super(key: key);

  @override
  State<CameraPreview> createState() => _CameraPreviewState();
}

class _CameraPreviewState extends State<CameraPreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CameraPreview"),
      ),
    );
  }
}
