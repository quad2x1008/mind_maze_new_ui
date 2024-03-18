import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mind_maze/common/ClsSound.dart';
import 'package:mind_maze/common/Common.dart';

class ShowAdDialog extends StatefulWidget {
  Function cancelTap;
  String subtitle;

  ShowAdDialog({required this.cancelTap, this.subtitle = "First complete the next level only then this level will be unlocked !"});

  @override
  State<ShowAdDialog> createState() => _ShowAdDialogState();
}

class _ShowAdDialogState extends State<ShowAdDialog> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Center(
        child: Container(
          height: 200.r,
          width: 300.r,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 165.r,
                  width: 300.r,
                  decoration: BoxDecoration(color: Color(0xff25245B), borderRadius: BorderRadius.circular(22.r),
                      image: DecorationImage(image: AssetImage("assets/Game/rect1.png"), fit: BoxFit.fill)),
                ),
              ),
              Container(
                height: 200.r,
                width: 300.r,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        height: 70.r,
                        width: 70.r,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: dialogBtnColor,
                            border: Border.all(color: txtColor.withOpacity(0.8), width: 2.r)),
                        child: Center(
                          child: Icon(Icons.live_tv_rounded, color: txtColor, size: 40.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 5.r),
                    Center(
                      child: Text("${widget.subtitle}", textAlign: TextAlign.center,
                          style: TextStyle(color: txtColor, fontSize: 18.r, decoration: TextDecoration.none)),
                    ),
                    SizedBox(height: 10.r),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          widget.cancelTap();
                          ClsSound.playSound(SOUNDTYPE.Tap);
                        },
                        child: Container(
                          height: 40.r,
                          width: 90.r,
                          decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/Game/btn_bg.png"), fit: BoxFit.fill)),
                          child: Center(
                            child: Text("CANCEL", textAlign: TextAlign.center, style: TextStyle(color: txtColor,
                                fontSize: 15.r, decoration: TextDecoration.none, letterSpacing: 1.r)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5.r),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
