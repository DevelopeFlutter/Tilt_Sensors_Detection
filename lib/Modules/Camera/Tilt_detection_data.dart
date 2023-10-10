import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../G Sensor/View Model/g_sensor_viewmodel.dart';

class Tiltdetection extends StatelessWidget {
  Tiltdetection({Key? key}) : super(key: key);
  final GSensorViewModel _gSensorController = Get.put(GSensorViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tilt detection Data"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
                "Total Length of Sensors is ${_gSensorController.normalDetectionData.length}"),
          ),
          Expanded(
            child: Obx(
                  () => ListView.builder(
                itemCount: _gSensorController.normalDetectionData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        _gSensorController.normalDetectionData[index].toString()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
