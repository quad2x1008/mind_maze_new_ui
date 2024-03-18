import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mind_maze/common/rate_dilog.dart';
import 'package:mind_maze/screens/account/LoginPage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Common.dart';
import 'EntryAnimation.dart';

/// Create By Khushi 06-04-2023
class ClsRateDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ClsRateDialogState();
  }
}

class ClsRateDialogState extends State<ClsRateDialog> {
  double _rating = 5;

  @override
  Widget build(BuildContext context) {
    return RateDialog(
      imageWidget: Container(),
      title: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Image.asset("assets/images/app_logo.png", height: 80.r, width: 100.r, fit: BoxFit.contain),
          ),
          SizedBox(height: 10.r),
          Text(AppName, textAlign: TextAlign.center, style: TextStyle(fontSize: 22.r, color: txtColor)),
        ],
      ),
      description: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Give us quick rating so we know,if you like it!!', textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.r, color: themeColor),
          ),
          Divider(
            color: Colors.black,
            height: 20.h,
          ),
          RatingBar.builder(
            initialRating: _rating,
            wrapAlignment: WrapAlignment.center,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 0),
            itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
            onRatingUpdate: (rating) {
              _rating = rating;
              setState(() {});
            },
          ),
          Divider(
            color: Colors.black,
            height: 20.h,
          ),
        ],
      ),
      entryAnimation: EntryAnimation.RIGHT,
      onlyOkButton: true,
      buttonOkColor: Colors.brown,
      buttonOkText: Text("SUBMIT", style: TextStyle(letterSpacing: 1.5.r, fontSize: 9.sp, color: Colors.white)),
      onOkButtonPressed: () {
        if (_rating <= 3.0 && Platform.isAndroid) {
          print('response.rating: $_rating');
          launchUrl(params);
          Navigator.pop(context);
        } else {
          launchUrl(Uri.parse(Platform.isIOS ? appStoreUrl : playStoreUrl), mode: LaunchMode.externalApplication);
          Navigator.pop(context);
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}


class ProDelDialog extends StatefulWidget {
  const ProDelDialog({Key? key}) : super(key: key);

  @override
  State<ProDelDialog> createState() => _ProDelDialogState();
}

class _ProDelDialogState extends State<ProDelDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: 300.r,
        width: 500.r,
        padding: EdgeInsets.all(10.r),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 180.r,
                padding: EdgeInsets.symmetric(horizontal: 20.r),
                decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/delbg.png"), fit: BoxFit.fill)),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 60.r),
                      Text("Are You Sure To Want Delete Profile ?", style: TextStyle(color: white, fontSize: 22.r), textAlign: TextAlign.center),
                      SizedBox(height: 25.r),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                            },
                            child: Text("YES", style: TextStyle(color: white, fontSize: 22.r)),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text("NO", style: TextStyle(color: white, fontSize: 22.r)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset("assets/images/home_icon.png", height: 100.r, width: 100.r, fit: BoxFit.fill),
            ),
          ],
        ),
      ),
    );
  }
}
