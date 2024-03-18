import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mind_maze/common/EntryAnimation.dart';
import 'package:mind_maze/common/rate_dilog.dart';
import 'package:share_extend/share_extend.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

String AppName = "Mind Maze Brain Games";

String iosId = "";
String appStoreUrl = "https://apps.apple.com/us/app/smart_brain_games/id$iosId";
String playStoreUrl = "";

///Please Don't any changes in this Url
const String playStoreMoreApp = "https://play.google.com/store/apps/developer?id=BN+Infotech&hl=en&gl=US";
const String appStoreMoreApp = "https://apps.apple.com/us/developer/pt-patel/id1259901941";

String share_msg = 'Hey use this Wonderful Game ! Sharpen Your Mind and Boost Your Brainpower with our Mind Maze Brain Games App!';
String commonBg = "assets/images/bg.png";
Color themeColor1 = Color(0xff181829);
Color txtColor = Color(0xffF6CD2A);
Color litetxtColor = Color(0xff7C89BB);
Color dialogBtnColor = Color(0xff6A5982);
Color bgColor = Color(0xffe8e8e8);

void shareApp() {
  String message = "$AppName\n$share_msg";
  if (playStoreUrl.isNotEmpty) {
    message += '\n\nFor PlayStore : $playStoreUrl';
  }
  if (appStoreUrl.isNotEmpty) {
    message += '\n\nFor AppStore : $appStoreUrl';
  }
  ShareExtend.share(message, 'text');
}

final Uri params = Uri(
  scheme: 'mailto',
  path: 'app.feedback4@gmail.com',
  query: 'subject=App Feedback&body=App $AppName',
);

String get getPrivacyUrl {
  if (Platform.isIOS) {
    return 'https://sites.google.com/view/ptpatel-privacypolicy/privacy-policy';
  } else if (Platform.isAndroid) {
    return 'https://sites.google.com/view/nidevs-privacy-policy/home';
  }
  return "";
}

moreApp() async {
  String str = playStoreMoreApp;
  if (Platform.isIOS) {
    str = appStoreMoreApp;
  }
  Uri url = Uri.parse(str);
  await canLaunchUrl(url) ? await launchUrl(url,mode: LaunchMode.externalApplication) : throw 'Could not launch $url';
}

Future<bool> backButton(BuildContext context) {
  print("Test== Beck Press");
  return Future.value(false);
}

Color red15 = Color(0x26E91E63);
Color red30 = Color(0x4DE91E63);
Color red45 = Color(0x73E91E63);
Color red60 = Color(0x99E91E63);
Color red75 = Color(0xBFE91E63);

Color themeColor = Color(0xff00BAD1);
Color primaryColor = Color(0xff00BAD1);
Color white = Colors.white;
Color black = Colors.black;

String get getAppUrl {
  if(Platform.isIOS) {
    return appStoreUrl;
  } else if(Platform.isAndroid) {
    return playStoreUrl;
  }
  return "";
}

String get getTopPointLBId {
  if (Platform.isIOS) {
    return "mind_maze_total_score";
  } else if (Platform.isAndroid) {
    return "CgkIhbLS2dMCEAIQAQ";
  }
  return "";
}

String get getTopGamePlayLBId {
  if (Platform.isIOS) {
    return "mind_maze_top_play";
  } else if (Platform.isAndroid) {
    return "CgkIhbLS2dMCEAIQBQ";
  }
  return "";
}

String get get25GamePlayACHId {
  if (Platform.isIOS) {
    return "25_game";
  } else if (Platform.isAndroid) {
    return "CgkIhbLS2dMCEAIQBg";
  }
  return "";
}

String get get50GamePlayACHId {
  if (Platform.isIOS) {
    return "50_game";
  } else if (Platform.isAndroid) {
    return "CgkIhbLS2dMCEAIQBw";
  }
  return "";
}

String get get100GamePlayACHId {
  if (Platform.isIOS) {
    return "100_game";
  } else if (Platform.isAndroid) {
    return "CgkIhbLS2dMCEAIQCg";
  }
  return "";
}

String get get1KPointACHId {
  if (Platform.isIOS) {
    return "1000_point";
  } else if (Platform.isAndroid) {
    return "CgkIhbLS2dMCEAIQCA";
  }
  return "";
}

String get get2500PointACHId {
  if (Platform.isIOS) {
    return "2500_point";
  } else if (Platform.isAndroid) {
    return "CgkIhbLS2dMCEAIQCQ";
  }
  return "";
}

String get get5KPointACHId {
  if (Platform.isIOS) {
    return "5000_point";
  } else if (Platform.isAndroid) {
    return "CgkIhbLS2dMCEAIQCw";
  }
  return "";
}

final BoxDecoration box_decoration = BoxDecoration(image: DecorationImage(image: AssetImage(commonBg), fit: BoxFit.cover));

extension Ex on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}

double? _rating;

Future showRatingDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => RateDialog(
      imageWidget: Container(),
      title: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset("assets/images/app_logo.png", height: 100, width: 100, fit: BoxFit.contain),
          ),
          Text(AppName, textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600, color: Colors.white)),
        ],
      ),
      description: Column(
        children: [
          Text('Do you like $AppName?', textAlign: TextAlign.center, style: TextStyle(fontSize: 14.sp, color: Colors.white)),
          Text('Give us quick rating so we know, if you like it!!', textAlign: TextAlign.center, style: TextStyle(fontSize: 14.sp, color: Colors.black)),
          Padding(
            padding: EdgeInsets.all(10),
            child: Image.asset("assets/images/divider.png"),
          ),
          RatingBar.builder(
            initialRating: _rating ?? 0.0,
            wrapAlignment: WrapAlignment.center,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 3),
            itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
            unratedColor: Colors.grey,
            onRatingUpdate: (rating) {
              _rating = rating;
            },
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Image.asset("assets/images/divider.png"),
          ),
        ],
      ),
      entryAnimation: EntryAnimation.RIGHT,
      onlyOkButton: true,
      buttonOkColor: Colors.blue,
      buttonOkText: Text("Submit", style: TextStyle(color: Colors.white)),
      onOkButtonPressed: () {
        if(_rating! <= 3.0 && Platform.isAndroid) {
          print("Response.rating: $_rating");
          launchUrl(params, mode: LaunchMode.externalApplication);
          Navigator.pop(context);
        } else {
          launchUrl(Uri.parse(getAppUrl),mode: LaunchMode.externalApplication);
          Navigator.pop(context);
          Container();
        }
      },
    ),
  );
}

List<String> notificationDesc = [
  "Don't forget to play your favorite game today!",
  "Ready for some fun? Mind Maze is waiting for you to play!",
  "It's been a while since you last played. Come back and enjoy Mind Maze!",
  "Time to level up! Mind Maze is waiting for you to continue your progress.",
  "Miss playing Mind Maze? Get back in the game and have some fun!",
  "Don't forget to play Brain Game today! It's a great way to unwind and have fun.",
  "It's time for your daily game play session. Get ready to dive into Mind Maze!",
  "Ready to level up? Mind Maze play session is about to start. Let's go!",
  "Need a break from work or studying? Take a quick game play break to recharge and refresh your mind.",
  "Don't miss out on today's daily challenge! Play now to complete your mission and earn rewards.",
  "Unleash your mind and conquer the maze!",
  "Are you ready to dive into the Mind Maze Brain?",
  "Embark on a journey of challenges and puzzles!",
  "Brain awaits your arrival in the Mind Maze!",
];

List<String> notificationTitle = [
  "Game On!",
  "Level Up Time",
  'Daily Challenge',
  'Time to Play',
  'Game Break',
  'Ready, Set, Play',
  "Let's Game",
  "Mission Reminder",
  "Quick Play Break",
  'Fun Time Ahead',
];
