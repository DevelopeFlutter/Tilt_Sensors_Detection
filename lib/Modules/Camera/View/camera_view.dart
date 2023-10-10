import 'dart:io';
import 'package:camerawesome/camerapreview.dart';
import 'package:camerawesome/models/capture_modes.dart';
import 'package:camerawesome/models/flashmodes.dart';
import 'package:camerawesome/models/sensors.dart';
import 'package:camerawesome/video_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import 'camera_preview.dart';

class CameraView extends StatefulWidget {
  const CameraView({Key? key}) : super(key: key);

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  final ValueNotifier<CameraFlashes> _switchFlash =
      ValueNotifier(CameraFlashes.AUTO);
  final ValueNotifier<Sensors> _sensor = ValueNotifier(Sensors.BACK);
  final ValueNotifier<CaptureModes> _captureMode =
      ValueNotifier(CaptureModes.VIDEO);
  final ValueNotifier<Size> _photoSize = ValueNotifier(const Size.square(512));

  final VideoController _videoController = VideoController();
  bool _isRecordingVideo = false;
  String _lastVideoPath = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CameraAwesome(
      captureMode: _captureMode,
      photoSize: _photoSize,
      sensor: _sensor,
      // enableAudio: _enableAudio,
      switchFlashMode: _switchFlash,
      onCameraStarted: () {
        _recordVideo();
        //
      },
    );
  }

  @override
  void dispose() {
    _photoSize.dispose();
    _captureMode.dispose();
    super.dispose();
  }

  _recordVideo() async {

    if (_isRecordingVideo) {
      await _videoController.stopRecordingVideo();

      _isRecordingVideo = false;
      setState(() {});

      final file = File(_lastVideoPath);
      await Future.delayed(const Duration(milliseconds: 300));
      Get.to(() => const CameraPreview());
    } else {
      final Directory extDir = await getTemporaryDirectory();
      final testDir =
          await Directory('${extDir.path}/test').create(recursive: true);
      final String filePath =
          '${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';
      await _videoController.recordVideo(filePath);
      _isRecordingVideo = true;
      _lastVideoPath = filePath;
      setState(() {});
    }
  }
}
