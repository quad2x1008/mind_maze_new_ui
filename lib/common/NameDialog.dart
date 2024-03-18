import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mind_maze/main.dart';
import 'ClsSound.dart';
import 'Key.dart';

class NameDialog extends StatelessWidget {
  final String? title, saveText;
  TextEditingController editText;

  double padding = 16.0.w;
  double avatarRadius = 40.0.w;

  VoidCallback? saveCallBack;

  NameDialog({required this.title, required this.editText, required this.saveText, required this.saveCallBack});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(padding)),
      elevation: 0.0.w,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: avatarRadius,
            bottom: padding,
            left: padding,
            right: padding
          ),
          margin: EdgeInsets.only(top: avatarRadius),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(padding),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(title!, style: TextStyle(fontSize: 18.r, fontWeight: FontWeight.w600, color: Colors.black87)),
              SizedBox(height: 10.0.h),
              Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border: Border.all(width: 2, color: Color(262626).withOpacity(0.6)),
                ),
                height: 50.h,
                alignment: Alignment.center,
                child: TextField(
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25.sp, color: Colors.black, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  controller: editText,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    helperStyle: TextStyle(fontSize: 10.sp, color: Colors.transparent, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 10.0.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 100.w,
                      height: 35.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(262626).withOpacity(0.3),
                          shape:RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.r))),
                        ),
                        onPressed: () {
                          ClsSound.playSound(SOUNDTYPE.Tap);
                          saveCallBack!();
                          session.write(KEY.KEY_Name, editText.text.toString());
                        },
                        child: Text(saveText!, style: TextStyle(color: Colors.white, fontSize: 16.r, fontWeight: FontWeight.normal)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: padding,
          right: padding,
          child: Container(
            alignment: Alignment.topCenter,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: avatarRadius,
              child: ClipOval(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/images/app_logo.png', width: 55.w, fit: BoxFit.fill),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
