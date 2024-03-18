import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mind_maze/common/ClsSound.dart';
import 'package:mind_maze/common/Common.dart';
import 'package:mind_maze/common/ShowAdDialog.dart';
import 'package:mind_maze/main.dart';
import 'package:mind_maze/screens/GameModel.dart';
import 'package:mind_maze/screens/ScoreBoard.dart';
import 'package:mind_maze/screens/TipsScreen.dart';
import 'package:mind_maze/screens/favouriteGame/FavouriteGames.dart';
import '../common/Key.dart';
import 'HomePage.dart';

class SelectGameScreen extends StatefulWidget {
  const SelectGameScreen({Key? key}) : super(key: key);

  @override
  State<SelectGameScreen> createState() => _SelectGameScreenState();
}

class _SelectGameScreenState extends State<SelectGameScreen> {
  String _searchQuery = '';

  List<GameModel> get _filteredGameModelList {
    return _searchQuery.isEmpty
        ? gameModelList
        : gameModelList.where((game) => game.gameTitle.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: box_decoration,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30.r, left: 20.r, right: 10.r, bottom: 10.r),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      ClsSound.playSound(SOUNDTYPE.Tap);
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return HomePage();
                        },
                      ));
                    },
                    child: Image.asset("assets/Game/back.png", height: 30.r, width: 40.r, fit: BoxFit.fill),
                  ),
                  Image.asset('assets/images/app_logo.png', height: 60.h, width: 60.w, fit: BoxFit.fill),
                  GestureDetector(
                    onTap: () {
                      ClsSound.playSound(SOUNDTYPE.Tap);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => FavouriteGames()));
                    },
                    child: Container(
                      width: 80.r,
                      height: 45.r,
                      decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/find_btn1.png"), fit: BoxFit.fill),
                          borderRadius: BorderRadius.circular(5.r), color: Color(0xff273156)),
                      child: Center(
                        child: Image.asset("assets/Game/heart_fill.png", fit: BoxFit.fill, height: 25.r, width: 25.r),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 15.r, right: 15.r),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 50.r,
                                width: 150.r,
                                decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/Game/select_btn.png'), fit: BoxFit.fill)),
                                child: Row(
                                  children: [
                                    SizedBox(width: 5.r),
                                    Image.asset('assets/Game/Achievement.png', color: Colors.orange, fit: BoxFit.fill, height: 30.r, width: 30.r),
                                    SizedBox(width: 5.r),
                                    Text('${session.read(KEY.KEY_TotalCompleteLevel) ?? 0}/${gameModelList.length}', style: TextStyle(color: Colors.white, fontSize: 16.sp)),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                ClsSound.playSound(SOUNDTYPE.Tap);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ScoreBoard()));
                              },
                              child: Container(
                                height: 50.r,
                                width: 150.r,
                                decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/Game/select_btn.png'), fit: BoxFit.fill)),
                                child: Row(
                                  children: [
                                    SizedBox(width: 5.r),
                                    Image.asset('assets/images/brain.png', height: 30.r, width: 30.r, fit: BoxFit.fill),
                                    SizedBox(width: 5.r),
                                    Text('${session.read(KEY.KEY_Point) ?? 0}', style: TextStyle(color: Colors.white, fontSize: 16.sp)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.r, left: 10.r, right: 10.r, bottom: 10.r),
                        child: TextFormField(
                          obscureText: false,
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              prefixIconColor: litetxtColor,
                              labelStyle: TextStyle(color: litetxtColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                borderSide: BorderSide(color: litetxtColor, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: BorderSide(color: litetxtColor, width: 1)
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: BorderSide(color: litetxtColor, width: 1)
                              ),
                              labelText: 'Search'
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                      ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          StaggeredGrid.count(
                            crossAxisCount: 3,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                            children: _filteredGameModelList.map<Widget>((item) {
                              return GestureDetector(
                                onTap: () {
                                  ClsSound.playSound(SOUNDTYPE.Tap);
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                    return TipsScreen(gameModel: item);
                                  }));
                                },
                                child: Stack(
                                  alignment: Alignment.topCenter,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(item.Training_icon, height: 100.h, width: 100.w),
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
                                        height: 100.h,
                                        width: 100.w,
                                        child: Card(
                                          color: Colors.black45,
                                          elevation: 3,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius:BorderRadius.all(Radius.circular(5)),
                                          ),
                                          child: Center(
                                            child: Icon(Icons.lock, size: 35.r, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
    // TODO: implement dispose
    super.dispose();
  }
}
