import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../AWS S3/View Model/aws_viewmodel_Getx_Controller.dart';
class EditSetting extends StatefulWidget {
  const EditSetting({Key? key}) : super(key: key);
  @override
  State<EditSetting> createState() => _EditSettingState();
}

class _EditSettingState extends State<EditSetting> {

  @override

  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Edit Setting"),
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
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(180, 50),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Edit Setting",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                // Get.to( const ViewScreen(title: '',));
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(180, 50),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Back",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            )
          ],
        ),
      ),
    );
  }
}
