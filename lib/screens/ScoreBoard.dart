import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mind_maze/common/Common.dart';
import 'package:mind_maze/main.dart';
import 'package:mind_maze/screens/GameModel.dart';
import '../common/ClsSound.dart';

class ScoreBoard extends StatefulWidget {
  const ScoreBoard({Key? key}) : super(key: key);

  @override
  State<ScoreBoard> createState() => _ScoreBoardState();
}

class _ScoreBoardState extends State<ScoreBoard> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: box_decoration,
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
                        Navigator.pop(context);
                      },
                      child: Image.asset("assets/Game/back.png", height: 30.r, width: 40.r, fit: BoxFit.fill),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(30.r, 5.r, 30.r, 5.r),
                      decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/Game/btn_bg.png"), fit: BoxFit.fill)),
                      child: Text("Score Board", style: TextStyle(color: txtColor, fontWeight: FontWeight.bold, fontSize: 25.r)),
                    ),
                    SizedBox(width: 60.r),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 80.w,
                            child: Column(
                              children: [
                                Text("Score", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16.sp)),
                                Text("Total Play", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16.sp)),
                              ],
                            ),
                          ),
                          Container(
                            width: 40.w,
                            child: Text("Top", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16.sp)),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            StaggeredGrid.count(
                              crossAxisCount: 1,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 10,
                              children: gameModelList.map<Widget>((item) {
                                return Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(item.Training_icon, height: 40.w, width: 40.w),
                                          SizedBox(width: 8.w),
                                          Align(
                                            alignment: Alignment.topCenter,
                                            child: Text(item.gameTitle, textAlign: TextAlign.center,
                                                style: TextStyle(color: Colors.white, fontSize: 16.sp)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 60.w,
                                            alignment: Alignment.centerRight,
                                            child: Column(
                                              children: [
                                                Text('${session.read("total_${item.id.index}") ?? 0}', textAlign: TextAlign.end,
                                                    style: TextStyle(color: Colors.white, fontSize: 16.sp)),
                                                Text('${session.read("GPlay_${item.id.index}") ?? 0}', textAlign: TextAlign.end,
                                                    style: TextStyle(color: Colors.white, fontSize: 16.sp))
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 40.w,
                                            alignment: Alignment.centerRight,
                                            child: Text('${session.read("hi_score_${item.id.index}") ?? 0}', textAlign: TextAlign.end,
                                                style: TextStyle(color: Colors.white, fontSize: 16.sp)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
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
