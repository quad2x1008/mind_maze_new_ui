import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimerTitle extends StatelessWidget {
  int current;

  TimerTitle(this.current);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Center(
          child: Text("$current", style: TextStyle(color: Colors.white, fontSize: 30.sp)),
        ),
        SizedBox(width: 5.0),
        Icon(Icons.timer_sharp, color: Colors.white),
        SizedBox(width: 5.0),
      ],
    );
  }
}
