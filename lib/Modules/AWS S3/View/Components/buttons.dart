import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:simple_s3/simple_s3.dart';

class ButtonVideoUploading {
  static deActivePrimaryButton({
    required BuildContext context,
    required String title,
    double height = 50,
    required Function callback,
    Color backGroundColor = Colors.grey,
  }) {
    var contextWidth = MediaQuery.of(context).size.width;
    return Material(
      borderRadius: BorderRadius.circular(100),
      color: backGroundColor.withOpacity(0.7),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () => {callback()},
        child: Container(
          height: height,
          width: contextWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              width: 2,
              color: backGroundColor,
            ),
          ),
          child: Center(
              child: Text(
            title,
            style: TextStyle(
              fontSize: contextWidth / 24,
              fontWeight: FontWeight.bold,
            ),
          )),
        ),
      ),
    );
  }

  static primaryButton({
    required BuildContext context,
    required String title,
    required Function callback,
    double height = 50,
    double fontsize = 0,
    Color backGroundColor = Colors.green,
  }) {
    var contextWidth = MediaQuery.of(context).size.width;
    return Material(
      borderRadius: BorderRadius.circular(100),
      color: backGroundColor.withOpacity(0.7),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () => {callback()},
        child: Container(
          height: height,
          width: contextWidth,decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            width: 2,
            color: backGroundColor,
          ),
        ),
          child: Center(
              child: Text(
            title,
            style: TextStyle(
              fontSize: fontsize == 0 ? contextWidth / 24 : fontsize,
              fontWeight: FontWeight.bold,
            ),
          )),
        ),
      ),
    );
  }

  static dataUploadingButton({
    required BuildContext context,
    double height = 50,
    String title = "CONFIRM",
    Color backGroundColor = Colors.green,
  }) {
    var contextWidth = MediaQuery.of(context).size.width;
    SimpleS3 _simpleS3 = SimpleS3();
    return StreamBuilder<dynamic>(
      stream: _simpleS3.getUploadPercentage,
      builder: (context, snapshot) {
        return LinearPercentIndicator(
          padding: EdgeInsets.zero,
          barRadius: const Radius.circular(100),
          animation: false,
          lineHeight: height,
          animationDuration: 2500,
          percent: snapshot.data != null ? (snapshot.data * 0.01) : 0.0,
          center: Text(
            snapshot.data != null
                ? snapshot.data.round().toString() + " %"
                : "0.0 %",
            style: TextStyle(
              fontSize: contextWidth / 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          linearStrokeCap: LinearStrokeCap.roundAll,
          backgroundColor: Colors.grey.withOpacity(0.5),
          progressColor: backGroundColor,
        );
      },
    );
  }
}
