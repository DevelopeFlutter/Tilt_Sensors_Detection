import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../../Camera/Camera.dart';
import '../../Camera/Edit_Setting.dart';
import '../../G Sensor/View/g_sensor.dart';
import '../View Model/aws_viewmodel_Getx_Controller.dart';

class ViewScreen extends StatefulWidget {
  final String title;

  const ViewScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  final AWSViewModel _serviceController = Get.put(AWSViewModel());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            submitButton(
              context: context,
              title: "Video Shot",
              color: Colors.orange,
              callback: () {
                Get.to(const Camera());
              },
            ),
            submitButton(
                context: context,
                title: "G Sensor",
                color: Colors.green,
                callback: () {
                  Get.to(
                    () => const GSensorView(),
                  );
                }),
            submitButton(
                context: context,
                title: "Edit setting",
                color: Colors.black,
                callback: () {
                  Get.to(const EditSetting());
                }),
            const SizedBox(
              height: 20,
            ),
            Obx(
              () => Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  _serviceController.videoURL.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget submitButton({
    required BuildContext context,
    required Function callback,
    required String title,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Material(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          splashColor: color.withOpacity(0.2),
          onTap: () {
            callback();
          },
          child: Container(
            height: 50,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: color),
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
