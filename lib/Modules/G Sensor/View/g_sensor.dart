import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Camera/Normal_detection_data.dart';
import '../../Camera/Tilt_detection_data.dart';
import '../View Model/g_sensor_viewmodel.dart';
class GSensorView extends StatefulWidget {
  const GSensorView({Key? key}) : super(key: key);
  @override
  State<GSensorView> createState() => _GSensorViewState();
}

class _GSensorViewState extends State<GSensorView> {
  GSensorViewModel getSensorsData = Get.put(GSensorViewModel());
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text("G-Sensor"),
        centerTitle: true,
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
Get.to(Normaldetection());
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(180, 50),
                // backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Normal Detection",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(Tiltdetection());
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(180, 50),
                // backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Tilt Detection",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            )
          ],
        ),
      ),
    );
  }
}
