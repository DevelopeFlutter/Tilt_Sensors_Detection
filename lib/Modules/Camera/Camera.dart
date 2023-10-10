// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables, non_constant_identifier_names
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../AWS S3/View Model/aws_viewmodel_Getx_Controller.dart';
import '../AWS S3/View/Components/Recorded_video.dart';
class Camera extends StatefulWidget {
  const Camera({
    Key? key,
  }) : super(key: key);

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  final AWSViewModel _getJsonFileData = Get.put(AWSViewModel());
  List SetData = [];
  Future<void> sensorsDataFile(
    String filename,
    dynamic content,
  ) async {
    Directory directory  =  Directory('/storage/emulated/0/Documents');
    final path = '${directory.path}/$filename';
    final file = File(path);
    _getJsonFileData.jsonFile.value = file;
    await file.writeAsString(content);
  }
  bool _isLoading = true;
  bool _isRecording = false;
  bool _forShowButton = false;
  var timer;
  bool forEvent = false;
  late CameraController _cameraController;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  final _streamSubscriptionsForDetectBrand = <StreamSubscription<dynamic>>[];

  final _tiltSubscription = <StreamSubscription<dynamic>>[];
  dynamic recordingTime = '0:0';
  void recordTime() {
    var startTime = DateTime.now();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      var diff = DateTime.now().difference(startTime);
      recordingTime =
          '${diff.inHours < 60 ? diff.inHours : 0}:${diff.inMinutes < 60 ? diff.inMinutes : 0}:${diff.inSeconds < 60 ? diff.inSeconds : diff.inSeconds % 60}';
      setState(() {});
    });
  }

  Future eventMethod(bool shouldAdd) async {
    bool temp = shouldAdd;
    _streamSubscriptions.add(
      accelerometerEvents.listen(
        (
          AccelerometerEvent event,
        ) {
          setState(() {
            DateTime Tme = DateTime.now();
            var data = {
              'x': event.x.toStringAsFixed(1),
              'y': event.y.toStringAsFixed(1),
              'z': event.z.toStringAsFixed(1),
              'timestamp': Tme,
            };
            if (temp) {
              data = {...data, "event": 'User has pressed Normal detection'};
              temp = false;
            }
            SetData.add(
              data,
            );
          });
        },
      ),
    );
  }

  Future detecteBrand(bool shouldAdd) async {
    bool temp = shouldAdd;
    _streamSubscriptionsForDetectBrand.add(
      accelerometerEvents.listen(
        (
          AccelerometerEvent event,
        ) {
          setState(() {
            DateTime Tme = DateTime.now();
            var data = {
              'x': event.x.toStringAsFixed(1),
              'y': event.y.toStringAsFixed(1),
              'z': event.z.toStringAsFixed(1),
              'timestamp': Tme,
            };
            if (temp) {
              data = {...data, "event": 'User has pressed Detect Brand'};
              temp = false;
            }
            SetData.add(
              data,
            );
          });
        },
      ),
    );
  }

  Future tiltDetection(bool shouldAdd) async {
    bool temp = shouldAdd;
    _tiltSubscription.add(
      accelerometerEvents.listen(
        (AccelerometerEvent event) {
          setState(() {
            DateTime Tme = DateTime.now();
            var data = {
              'x': event.x.toStringAsFixed(1),
              'y': event.y.toStringAsFixed(1),
              'z': event.z.toStringAsFixed(1),
              'timestamp': Tme,
            };
            if (temp) {
              data = {...data, "event": 'User has pressed Tilt detection'};
              temp = false;
            }
            SetData.add(data);
          });
        },
      ),
    );
  }

  _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);
    _cameraController = CameraController(front, ResolutionPreset.veryHigh);
    await _cameraController.initialize();
    setState(() {
      _isLoading = false;
    });
  }
  _recordVideo() async {
    if (_isRecording) {
      final file = await _cameraController.stopVideoRecording();

      setState(() {
        for (final subscription in _streamSubscriptions) {
          subscription.cancel();
        }
        for (final subscription in _tiltSubscription) {
          subscription.cancel();
        }
        for (final subscription in _streamSubscriptionsForDetectBrand) {
          subscription.cancel();
        }

        _isRecording = false;
      });
      timer.cancel();
      final route = MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => VideoPage(filePath: file.path),
      );
      Navigator.push(context, route);
      sensorsDataFile('user_input.json',SetData.toString());
    } else {
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      SetData.clear();
      setState(() => _isRecording = true);
      eventMethod(false);
      recordTime();
    }
  }

  void toggleButton() {
    setState(() {
      _forShowButton = !_forShowButton;
    });
  }
  @override
  void initState() {
    _initCamera();
    super.initState();
  }
  @override
  void dispose() {
    _cameraController.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    for (final subscription in _tiltSubscription) {
      subscription.cancel();
    }
    for (final subscription in _streamSubscriptionsForDetectBrand) {
      subscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Center(
          child: Stack(
        alignment: Alignment.center,
        children: [
          CameraPreview(_cameraController),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Align(
                alignment: Alignment.topCenter,
                child:
                    _isRecording ? Material(child: Text(recordingTime)) : null),
          ),
          Align(
              alignment: Alignment.bottomLeft,
              child: _isRecording
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 70, left: 5),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            for (final subscription in _streamSubscriptions) {
                              subscription.cancel();
                            }
                            detecteBrand(true);
                            toggleButton();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(140, 50),
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text(
                          "Detect brand",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  : null),
          Align(
              alignment: Alignment.bottomRight,
              child: _forShowButton && _isRecording
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 120, right: 5),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _forShowButton = false;
                          });
                          tiltDetection(true);
                          for (final subscription in _streamSubscriptions) {
                            subscription.cancel();
                          }
                          for (final subscription
                              in _streamSubscriptionsForDetectBrand) {
                            subscription.cancel();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(156, 50),
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Tilt detection",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    )
                  : null),
          Align(
              alignment: Alignment.bottomRight,
              child: _forShowButton && _isRecording
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 180, right: 5),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _forShowButton = false;
                          });
                          eventMethod(true);
                          for (final subscription in _tiltSubscription) {
                            subscription.cancel();
                          }
                          for (final subscription
                              in _streamSubscriptionsForDetectBrand) {
                            subscription.cancel();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(156, 50),
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Normal detection",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    )
                  : null),
          Padding(
            padding: const EdgeInsets.only(left: 15, bottom: 75, right: 23),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                child: Icon(_isRecording ? Icons.stop : Icons.circle),
                onPressed: () => _recordVideo(),
              ),
            ),
          ),
        ],
      ));
    }
  }
}
