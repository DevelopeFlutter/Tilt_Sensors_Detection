// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../preview_recorded_vedio.dart';

class VideoPage extends StatefulWidget {
  dynamic filePath;
  VideoPage({Key? key, required this.filePath}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _videoPlayerController;

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.file(File(widget.filePath));
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.pause();
  }

  void saveToGallery() async {
    await GallerySaver.saveVideo(widget.filePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black26,
        actions: [
          ElevatedButton(
              onPressed: () {
                saveToGallery();
              },
              child: const Text(
                'Save video to Gallery',
                style: TextStyle(fontSize: 16),
              )),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Get.to(
                  RegistrationVedioView(vedioFilePath: File(widget.filePath)));
            },
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        alignment: Alignment.center,
        children: [
          FutureBuilder(
            future: _initVideoPlayer(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return VideoPlayer(_videoPlayerController);
              }
            },
          ),
        ],
      ),
    );
  }
}
