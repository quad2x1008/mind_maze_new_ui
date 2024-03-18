import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mind_maze/common/Common.dart';

int oldPoint = 0;
int newPoint = 0;

class LiveScorePoint extends StatelessWidget {
  int correct;
  int incorrect;
  int currentTime;
  int totalTime;

  LiveScorePoint(this.correct, this.incorrect, this.currentTime, this.totalTime);

  @override
  Widget build(BuildContext context) {
    try {
      oldPoint = newPoint;
      newPoint = (correct*100/(totalTime-currentTime)).toInt()-incorrect;
    } catch (e) {}
    return Row(
      children: [
        Center(
          child: Image.asset("assets/images/brain.png", height: 30.h, width: 30.h),
        ),
        SizedBox(width: 5.0),
        Center(
          child: Countup(
            begin: oldPoint.toDouble(),
            end: newPoint.toDouble(),
            duration: Duration(milliseconds: 500),
            textAlign: TextAlign.center,
            style: TextStyle(color: litetxtColor, fontSize: 20.sp),
          ),
        ),
        SizedBox(width: 5.0),
      ],
    );
  }
}
