import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mind_maze/common/ClsRateDialog.dart';
import 'package:mind_maze/common/ClsSound.dart';
import 'package:mind_maze/common/EntryAnimation.dart';
import 'package:mind_maze/common/network.dart';
import 'package:mind_maze/screens/Play%20with%20frd/LevelPage.dart';
import 'package:mind_maze/screens/SelectGameScreen.dart';
import 'package:mind_maze/screens/setting/SettingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/Common.dart';
import '../image_picker/DBHelper.dart';
import '../image_picker/Photo.dart';
import '../image_picker/Utility.dart';
import 'account/UpdatePage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late SharedPreferences _prefs;
  late String _name = '';
  late String _email = '';
  late String _mobileNumber = '';

  late Future<File> imageFile;
  late Image image;
  late DBHelper dbHelper;
  late List<Photo> images;

  @override
  void initState() {
    super.initState();
    images = [];
    dbHelper = DBHelper();
    refreshImages();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _prefs = prefs;
        _name = _prefs.getString('name') ?? '';
        _email = _prefs.getString('email') ?? '';
        _mobileNumber = _prefs.getString('mobileNumber') ?? '';
      });
    });
    print("HomePage = Username : $_name, Email ID : $_email, Mobile No : $_mobileNumber");
  }

  refreshImages() {
    dbHelper.getPhotos().then((imgs) {
      setState(() {
        images.clear();
        images.addAll(imgs);
      });
    });
  }

  pickImageFromGallery() {
    ImagePicker().pickImage(source: ImageSource.gallery).then((XFile? imgFile) {
      if (imgFile != null) {
        imgFile.readAsBytes().then((List<int> bytes) {
          Uint8List imgBytes = Uint8List.fromList(bytes);
          String imgString = Utility.base64String(imgBytes);
          Photo photo = Photo(id: 0, photoName: imgString);

          if (images.isEmpty) {
            setState(() {
              images.add(photo);
              dbHelper.save(photo);
            });
          } else {
            setState(() {
              images[0] = photo;
              dbHelper.update(photo);
            });
          }
        });
      }
    });
  }

  gridView() {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: images.map((photo) {
          return Utility.imageFromBase64String(photo.photoName!);
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String truncatedName = _name.length > 10 ? _name.substring(0, 10) + "..." : _name;
    String truncatedEmail = _email.length > 25 ? _email.substring(0, 25) + "..." : _email;

    return WillPopScope(
      onWillPop: () async {
        bool value = await showDialog(
          context: context,builder: (context) => NetworkGiffyDialog(
            image: Image.asset("assets/images/divider.png", height: 20.h, width: 20.w),
            title: Text('Are you sure?', textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22.r, fontWeight: FontWeight.w600, color: black)),
            description:Text('Do you want to exit an App', textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.r, color: black)),
            entryAnimation: EntryAnimation.RIGHT,
            onOkButtonPressed: () {
              SystemNavigator.pop();
            },
          ),
        );
        return value;
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        drawer: Drawer(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: box_decoration,
            child: Column(
              children: [
                Container(
                  height: 260.h,
                  width: double.infinity,
                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/drawerimg.png"), fit: BoxFit.fill)),
                  child: Padding(
                    padding: EdgeInsets.only(top: 40.r),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10.r, left: 20.r, bottom: 5.r),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Welcome, $truncatedName", style: TextStyle(color: Colors.white, fontSize: 22.r)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.r),
                          child: Center(
                            child: Container(
                              height: 100.h,
                              width: 120.w,
                              child: Stack(
                                children:[
                                  Align(
                                    alignment:Alignment.center,
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: AssetImage("assets/images/camera.png"),
                                      child: Padding(
                                        padding: EdgeInsets.all(5.r),
                                        child: ClipOval(
                                            child: images.isNotEmpty
                                                ? Image.memory(base64Decode(images[0].photoName!), height: 100.h, width: 100.h, fit: BoxFit.contain)
                                                : Image.asset("assets/person/1.jpg", height: 100.h, width: 100.h, fit: BoxFit.contain)
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 60),
                                    child: Align(
                                      alignment:Alignment.topCenter,
                                      child: GestureDetector(
                                        onTap: () {
                                          pickImageFromGallery();
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 35,
                                          decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/camera.png"), fit: BoxFit.fill)),
                                          child: Icon(Icons.camera, size: 30, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20.r),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Icon(Icons.email, size: 25, color: Colors.white),
                                SizedBox(width: 5.r),
                                Text(truncatedEmail, style: TextStyle(color: Colors.white, fontSize: 18.r)),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.r, left: 20.r),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Icon(Icons.phone, size: 25, color: Colors.white),
                                SizedBox(width: 5.r),
                                Text(_mobileNumber, style: TextStyle(color: Colors.white, fontSize: 18.r)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text("Home", style: TextStyle(color: white, fontSize: 22.r, fontFamily: 'SC')),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                          leading: Icon(Icons.home, color: white),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Text("Profile Update", style: TextStyle(color: white, fontSize: 22.r, fontFamily: 'SC')),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                          leading: Icon(Icons.person, color: white),
                          onTap: () async {
                            ClsSound.playSound(SOUNDTYPE.Tap);
                            Navigator.pop(context);

                            final updatedData = await Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePage(
                              currentName: _name,
                              currentEmail: _email,
                              currentMobile: _mobileNumber,
                            )));

                            if (updatedData != null) {
                              setState(() {
                                _name = updatedData['name'];
                                _email = updatedData['email'];
                                _mobileNumber = updatedData['mobile'];
                              });
                            }
                          },
                        ),
                        ListTile(
                          title: Text("Setting", style: TextStyle(color: white, fontSize: 22.r, fontFamily: 'SC')),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                          leading: Icon(Icons.settings, color: white),
                          onTap: () {
                            ClsSound.playSound(SOUNDTYPE.Tap);
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen(currentName: _name, images: images)));
                          },
                        ),
                        ListTile(
                          title: Text("Share", style: TextStyle(color: white, fontSize: 22.r, fontFamily: 'SC')),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                          leading: Icon(Icons.share, color: white),
                          onTap: () {
                            ClsSound.playSound(SOUNDTYPE.Tap);
                            shareApp();
                          },
                        ),
                        ListTile(
                          title: Text("Rate Us", style: TextStyle(color: white, fontSize: 22.r, fontFamily: 'SC')),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                          leading: Icon(Icons.star_rate_rounded, color: white),
                          onTap: () {
                            ClsSound.playSound(SOUNDTYPE.Tap);
                            showDialog(
                              context: context,
                              builder: (context) {
                                return ClsRateDialog();
                              },
                            );
                          },
                        ),
                        ListTile(
                          title: Text("More app", style: TextStyle(color: white, fontSize: 22.r, fontFamily: 'SC')),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                          leading: Icon(Icons.apps_rounded, color: white),
                          onTap: () {
                            ClsSound.playSound(SOUNDTYPE.Tap);
                            moreApp();
                          },
                        ),
                        ListTile(
                          title: Text("Profile Delete", style: TextStyle(color: white, fontSize: 22.r, fontFamily: 'SC')),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                          leading: Icon(Icons.delete, color: white),
                          onTap: () {
                            ClsSound.playSound(SOUNDTYPE.Tap);
                            showDialog(
                              context: context,
                              builder: (context) {
                                return ProDelDialog();
                              },
                            );
                          },
                        ),
                        SizedBox(height: 50.h),
                        Image.asset("assets/images/divider.png", width: 200.w, color: white),
                        ListTile(
                          title: Text("MIND MAZE BRAIN GAME", style: TextStyle(color: Colors.white, fontSize: 22.r, fontFamily: 'SC')),
                        ),
                        Image.asset("assets/images/divider.png", width: 200.w, color: white),
                        SizedBox(height: 5.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: box_decoration,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 30.r, left: 10.r, right: 10.r, bottom: 10.r),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                      child: Container(
                        height: 45.r,
                        width: 80.r,
                        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/find_btn1.png"), fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(5.r), color: Color(0xff273156)),
                        child: Center(
                          child: Icon(Icons.menu, color: txtColor.withOpacity(0.8), size: 28.r),
                        ),
                      ),
                    ),
                    Image.asset('assets/images/app_logo.png', height: 60.h, width: 60.w, fit: BoxFit.fill),
                    GestureDetector(
                      onTap: () async {
                        Future<TimeOfDay?> selectedTime = showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                        );
                        selectedTime.then((time) {
                          if (time != null) {
                            Notify();
                          }
                        });
                      },
                      child: Container(
                        height: 45.r,
                        width: 80.r,
                        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/find_btn1.png"), fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(5.r), color: Color(0xff273156)),
                        child: Center(
                          child: Icon(Icons.alarm, color: txtColor.withOpacity(0.8), size: 28.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 500.r,
                        width: 350.r,
                        padding: EdgeInsets.all(10.r),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 410.r,
                                padding: EdgeInsets.symmetric(horizontal: 20.r),
                                decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/rect1.png"), fit: BoxFit.fill)),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 30.r),
                                      Text("Choose One Of The Two Game Options To Start Playing.!!", textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 15.r, color: txtColor, letterSpacing: 1.r),
                                      ),
                                      SizedBox(height: 10.r),
                                      InkWell(
                                        onTap: () {
                                          ClsSound.playSound(SOUNDTYPE.Tap);
                                          Navigator.push(context, MaterialPageRoute(
                                            builder: (context) {
                                              return SelectGameScreen();
                                            },
                                          ));
                                        },
                                        child: Container(
                                          height: 100.r,
                                          width: 0.6.sw,
                                          child: Stack(
                                            children: [
                                              Align(
                                                alignment: Alignment.bottomCenter,
                                                child: Container(
                                                  height: 100.r,
                                                  width: 0.8.sw,
                                                  margin: EdgeInsets.only(top: 20.r),
                                                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/home_btn.png"), fit: BoxFit.fill)),
                                                  padding: EdgeInsets.only(left: 0.15.sw),
                                                  alignment: Alignment.centerLeft,
                                                  child: Text("Single\nPlayer",textAlign: TextAlign.center, style: TextStyle(color: Color(0xffF6CD2A), fontSize: 20.r, fontWeight: FontWeight.bold)),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: Container(
                                                  height: 80.r,
                                                  width: 80.r,
                                                  margin: EdgeInsets.only(right: 10.r),
                                                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/btn.png"), fit: BoxFit.fill)),
                                                  child: Center(
                                                    child: Image.asset("assets/images/player.png", fit: BoxFit.fill, height: 50.r, width: 50.r),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20.r),
                                      InkWell(
                                        onTap: () {
                                          ClsSound.playSound(SOUNDTYPE.Tap);
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => LevelPage()));
                                          setState(() {});
                                        },
                                        child: Container(
                                          height: 100.r,
                                          width: 0.6.sw,
                                          child: Stack(
                                            children: [
                                              Align(
                                                alignment: Alignment.bottomCenter,
                                                child: Container(
                                                  height: 100.r,
                                                  width: 0.8.sw,
                                                  margin: EdgeInsets.only(top: 20.r),
                                                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/home_btn.png"), fit: BoxFit.fill)),
                                                  padding: EdgeInsets.only(left: 0.25.sw),
                                                  alignment: Alignment.centerLeft,
                                                  child: Text("Multiple\nPlayer",textAlign: TextAlign.center, style: TextStyle(color: Color(0xffF6CD2A), fontSize: 20.r, fontWeight: FontWeight.bold)),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Container(
                                                  height: 80.r,
                                                  width: 80.r,
                                                  margin: EdgeInsets.only(left: 10.r),
                                                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/btn.png"), fit: BoxFit.fill)),
                                                  child: Center(
                                                    child: Image.asset("assets/images/team.png", fit: BoxFit.fill, height: 50.r, width: 50.r),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Image.asset("assets/images/home_icon.png", fit: BoxFit.fill, height: 150.r, width: 150.r),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void Notify() async {
  String randomSentence = notificationDesc[Random().nextInt(notificationDesc.length)];
  String randomTitle = notificationTitle[Random().nextInt(notificationTitle.length)];

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
        id: 1,
        channelKey: 'key1',
        title: randomTitle,
        body: randomSentence,
    ),
  );
}
