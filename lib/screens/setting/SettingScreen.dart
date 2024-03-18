import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mind_maze/common/ClsSound.dart';
import '../../common/Common.dart';
import '../../common/Key.dart';
import '../../image_picker/Photo.dart';
import '../../main.dart';
import '../HomePage.dart';

class SettingScreen extends StatefulWidget {
  final String? currentName;
  late List<Photo> images;

  SettingScreen({Key? key, this.currentName, required this.images}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  static const num1 = "123456789";
  String icon = "assets/person/${num1[Random().nextInt(8)+1]}.jpg";
  TextEditingController txtName = TextEditingController(text: session.read(KEY.KEY_Name)??"Player");

  @override
  void initState() {
    session.writeIfNull(KEY.KEY_Icon, icon);
    super.initState();
    initdata();
  }

  @override
  Widget build(BuildContext context) {
    String? truncatedName = widget.currentName!.length > 10 ? widget.currentName!.substring(0, 10) + "..." : widget.currentName;

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage(commonBg), fit: BoxFit.fill)),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30.r, left: 20.r, right: 10.r, bottom: 10.r),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    child: Image.asset("assets/Game/back.png", height: 30.r, width: 40.r, fit: BoxFit.fill),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Image.asset("assets/images/brain.png", height: 30.r, width: 30.r, fit: BoxFit.cover),
                        SizedBox(width: 2.r),
                        Text("${session.read(KEY.KEY_Point) ?? 0}", style: TextStyle(color: txtColor, fontSize: 20.sp))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 135.h,
                      width: 135.w,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage("assets/images/camera.png"),
                        child: Padding(
                          padding: EdgeInsets.all(5.r),
                          child: ClipOval(
                              child: widget.images.isNotEmpty
                                  ? Image.memory(base64Decode(widget.images[0].photoName!), height: 125.h, width: 125.w, fit: BoxFit.contain)
                                  : Image.asset("assets/person/1.jpg", height: 125.h, width: 125.w, fit: BoxFit.contain)
                          ),
                        ),
                      ),
                    ),
                    Text("$truncatedName", style: TextStyle(color: txtColor, fontSize: 30.r)),
                    Padding(padding: EdgeInsets.all(10)),
                    Container(
                      margin: EdgeInsets.only(left: 15.r, right: 15.r),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 50.r,
                            width: 150.r,
                            margin: EdgeInsets.only(right: 5.r),
                            decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/Game/select_btn.png'), fit: BoxFit.fill)),
                            child: Row(
                              children: [
                                SizedBox(width: 5.r),
                                Image.asset('assets/Game/accuracy.png', fit: BoxFit.fill, height: 30.r, width: 30.r),
                                SizedBox(width: 5.r),
                                Text('Avg: ${(session.read(KEY.KEY_Avg_Accuarcy.padLeft(2)))??0} %', style: TextStyle(color: Colors.white, fontSize: 14.r)),
                              ],
                            ),
                          ),
                          Container(
                            height: 50.r,
                            width: 150.r,
                            margin: EdgeInsets.only(left: 5.w),
                            decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/Game/select_btn.png'), fit: BoxFit.fill)),
                            child: Row(
                              children: [
                                SizedBox(width: 5.r),
                                Image.asset('assets/Game/games.png', height: 30.r, width: 30.r, fit: BoxFit.fill, color: Colors.lightBlueAccent),
                                SizedBox(width: 5.r),
                                Text('TotalGame: ${session.read(KEY.KEY_GameCount) ?? 0}', style: TextStyle(color: Colors.white, fontSize: 14.r)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListView(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      children: [
                        GestureDetector(
                          onTap: () {
                            session.write(KEY.KEY_Music, !(session.read(KEY.KEY_Music) ?? true));
                            ClsSound.playSound(SOUNDTYPE.Tap);
                            ClsSound.playMusic();
                            setState(() {});
                          },
                          child: settingItem(icon: (session.read(KEY.KEY_Music) ?? true) ? Icons.volume_up_rounded : Icons.volume_off_rounded, title: "Game Music"),
                        ),
                        GestureDetector(
                          onTap: () {
                            session.write(KEY.KEY_Sound, !(session.read(KEY.KEY_Sound) ?? true));
                            ClsSound.playSound(SOUNDTYPE.Tap);
                            setState(() {});
                          },
                          child: settingItem(i: 1, icon: (session.read(KEY.KEY_Sound) ?? true) ? Icons.music_note_rounded : Icons.music_off_rounded, title: "Game Sound"),
                        ),
                        GestureDetector(
                          onTap: () {
                            session.write(KEY.KEY_Vibrate, !(session.read(KEY.KEY_Vibrate) ?? true));
                            ClsSound.playSound(SOUNDTYPE.Tap);
                            setState(() {});
                          },
                          child: settingItem(icon: (session.read(KEY.KEY_Vibrate) ?? true) ? Icons.vibration : Icons.close, title: "Game Vibrate"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

  void initdata() async {
    setState(() {});
    icon = "${session.read(KEY.KEY_Icon) ?? session.write(KEY.KEY_Icon, icon)}";
  }

  settingItem({required IconData icon, required String title, int i = 0}) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.r),
      height: 75.r,
      width: 0.6.sw,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 55.r,
              width: 0.6.sw,
              decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/Game/setting_btn.png"), fit: BoxFit.fill)),
              padding: i == 0 ? EdgeInsets.only(right: 0.10.sw) : EdgeInsets.only(left: 0.10.sw),
              alignment: i == 0 ? Alignment.centerRight : Alignment.centerLeft,
              child: Text(title, style: TextStyle(color: txtColor, fontSize: 20.r, fontWeight: FontWeight.bold)),
            ),
          ),
          i == 0 ? Positioned(
            left: 0.22.sw,
            top: 0,
            child: Container(
              height: 50.r,
              width: 50.r,
              decoration: BoxDecoration(color: txtColor, shape: BoxShape.circle, image: DecorationImage(image: AssetImage("assets/Game/round_empty.png"), fit: BoxFit.fill)),
              child: Center(
                child: Icon(icon, color: black, size: 30.r),
              ),
            ),
          ) : Positioned(
            right: 0.22.sw,
            top: 0,
            child: Container(
              height: 50.r,
              width: 50.r,
              decoration: BoxDecoration(color: txtColor, shape: BoxShape.circle, image: DecorationImage(image: AssetImage("assets/Game/round_empty.png"), fit: BoxFit.fill)),
              child: Center(
                child: Icon(icon, color: black, size: 30.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

