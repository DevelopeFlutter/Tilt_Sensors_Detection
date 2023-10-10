import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../G Sensor/View Model/g_sensor_viewmodel.dart';
import '../View Model/aws_viewmodel_Getx_Controller.dart';
import '../aws_s3_image_vedio_uploading.dart';
import 'Components/buttons.dart';
import 'view_screen.dart';

class RegistrationVedioView extends StatefulWidget {
  dynamic vedioFilePath;

  bool isReview;
  RegistrationVedioView({
    Key? key,
    required this.vedioFilePath,
    this.isReview = false,
  }) : super(key: key);

  @override
  State<RegistrationVedioView> createState() => _RegistrationVedioViewState();
}

class _RegistrationVedioViewState extends State<RegistrationVedioView> {
  late VideoPlayerController _videoPlayerController;
  final AWSViewModel _serviceController = Get.put(AWSViewModel());

  @override
  void initState() {
    // TODO: implement initState
    _videoPlayerController = VideoPlayerController.file(widget.vedioFilePath!)
      ..initialize().then((_) {
        setState(() {

        });
        _videoPlayerController.pause();
        _videoPlayerController.position;
      });
    super.initState();
  }

//! Player indicatior Show / Hide
  bool isShow = true;
  iconShowOnVedio({
    int milisecond = 1000,
  }) {
    Future.delayed(Duration(milliseconds: milisecond), () {
      setState(() {
        isShow = false;
      });
    });
  }

  bool isPlay = false;
  @override
  Widget build(BuildContext context) {
    var contextWidth = MediaQuery.of(context).size.width;
    var contextHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        setState(() {
          isShow = true;
        });
        iconShowOnVedio();
      },
      child: SizedBox(
        width: contextWidth,
        height: contextHeight,
        child: Stack(
          children: [
            VideoPlayer(
              _videoPlayerController,
            ),
            widget.isReview
                ? Positioned(
                    bottom: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: SizedBox(
                        height: 50,
                        width: contextWidth,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: ButtonVideoUploading.deActivePrimaryButton(
                                context: context,
                                title: "PREVIEW",
                                callback: () {
                                  _videoPlayerController.play();
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: ButtonVideoUploading.primaryButton(
                                context: context,
                                backGroundColor: Colors.red,
                                title: "CANCEL",
                                callback: () {
                                  Get.back();
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Positioned(
                    bottom: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: SizedBox(
                        height: 120,
                        width: contextWidth,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: ButtonVideoUploading
                                      .deActivePrimaryButton(
                                    context: context,
                                    title: "PREVIEW",
                                    callback: () {
                                      _videoPlayerController.play();
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: ButtonVideoUploading.primaryButton(
                                    context: context,
                                    backGroundColor: Colors.red,
                                    title: "Delete Video",
                                    callback: () {
                                      _videoPlayerController.pause();
                                      Get.to(const ViewScreen(title: ''));
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: isloading
                                  ? ButtonVideoUploading.dataUploadingButton(
                                      context: context)
                                  : ButtonVideoUploading.primaryButton(
                                      context: context,
                                      title: "Upload to S3",
                                      callback: () async {
                                        callingMethod();
                                      },
                                    ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  callingMethod() async {
    setState(
      () {
        _serviceController.vedioFile.value = widget.vedioFilePath;
      },
    );

    // await fileUpload();
      await videoUpload();
    Get.close(1);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const ViewScreen(
          title: 'Amazon AWS-S3 Server',
        ),
      ),
      (Route<dynamic> route) => true,
    );
  }
  bool isloading = false;
  videoUpload() async {
    setState(() {
      isloading = true;
    });
    await fileUpload();
    _serviceController.videoURL.value = (await upload_AWS_S3(
      filePath: widget.vedioFilePath,
      context: context,
      isVideo: true,
    ))!;
    setState(() {
      isloading = false;
    });
  }
  fileUpload() async {
    _serviceController.fileURL.value = (await upload_AWS_S3Json(
      file:_serviceController.jsonFile.value,
      context: context,
      isFile: true,
    ))!;
  }
}
