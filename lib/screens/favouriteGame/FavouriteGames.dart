import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mind_maze/common/Common.dart';
import 'package:mind_maze/main.dart';
import 'package:mind_maze/screens/GameModel.dart';
import 'package:mind_maze/screens/SelectGameScreen.dart';
import 'package:mind_maze/screens/TipsScreen.dart';
import '../../common/ClsSound.dart';
import '../../common/Key.dart';

class FavouriteGames extends StatefulWidget {
  const FavouriteGames({Key? key}) : super(key: key);

  @override
  State<FavouriteGames> createState() => _FavouriteGamesState();
}

class _FavouriteGamesState extends State<FavouriteGames> {
  List favList = [];

  @override
  Widget build(BuildContext context) {
    favList = jsonDecode(session.read(KEY.KEY_Favourite) ?? '[]');
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage(commonBg), fit: BoxFit.cover)),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 30.r, left: 20.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        ClsSound.playSound(SOUNDTYPE.Tap);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SelectGameScreen()));
                      },
                      child: Image.asset("assets/Game/back.png", height: 30.r, width: 40.r, fit: BoxFit.fill),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(30.r, 5.r, 30.r, 5.r),
                      decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/Game/btn_bg.png"), fit: BoxFit.fill)),
                      child: Text("Favourite Games", style: TextStyle(color: txtColor, fontWeight: FontWeight.bold, fontSize: 25.r)),
                    ),
                    SizedBox(width: 20.r),
                  ],
                ),
              ),
              Expanded(
                child: favList.isEmpty? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: Image.asset("assets/Game/noFav.png", height: 150.h, width: 150.w)),
                    Center(child: Text("Oops...!", style: TextStyle(color: txtColor, fontSize: 22, fontWeight: FontWeight.bold))),
                    Center(child: Text("You don't have any favorite Game.", style: TextStyle(color: txtColor, fontSize: 18))),
                  ],
                ):SingleChildScrollView(
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      StaggeredGrid.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        children: gameModelList.where((element) => favList.contains(element.gameId)).map<Widget>((item) {
                          return Center(
                            child: GestureDetector(
                              onTap: () {
                                ClsSound.playSound(SOUNDTYPE.Tap);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => TipsScreen(gameModel: item))).then((value) {
                                  setState(() {});
                                });
                              },
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(item.Training_icon, height: 90.w, width: 90.w),
                                      Padding(padding: EdgeInsets.all(5.0)),
                                      SizedBox(
                                        height: 42.h,
                                        child: Text(item.gameTitle, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 14.sp)),
                                      ),
                                    ],
                                  ),
                                  Visibility(
                                    visible: item.isLock && !((session.read(KEY.KEY_Unlock) ?? []) as List).contains(item.id.index),
                                    child: Container(
                                      height: 90.w,
                                      width: 90.w,
                                      child: Card(
                                        color: Colors.black12,
                                        elevation: 3,
                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                        child: Center(child: Icon(Icons.lock, size: 35.r)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
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

  @override
  void initState() {
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
    super.dispose();
  }
}
