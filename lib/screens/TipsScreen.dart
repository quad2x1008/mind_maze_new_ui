import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mind_maze/common/ClsSound.dart';
import 'package:mind_maze/common/Common.dart';
import 'package:mind_maze/screens/Chroma%20Shapes/ChromaShapesScreen.dart';
import 'package:mind_maze/screens/Color%20Sense/ColorSenseScreen.dart';
import 'package:mind_maze/screens/Find%20Color/ColorQuestScreen.dart';
import 'package:mind_maze/screens/Find%20Quest/FindQuestScreen.dart';
import 'package:mind_maze/screens/GameModel.dart';
import 'package:mind_maze/screens/Number%20Sorter/NumberSorterScreen.dart';
import 'package:mind_maze/screens/Pic%20Match/PicMatchScreen.dart';
import 'package:mind_maze/screens/SelectGameScreen.dart';
import 'package:mind_maze/screens/Shapes%20Image%20Quest/ShapesQuestScreen.dart';
import 'package:mind_maze/screens/StopTheBall/StopTheBallGameScreen.dart';
import 'package:mind_maze/screens/Visual%20Mastery/VisualMasteryScreen.dart';
import 'package:mind_maze/screens/game_addition_addiction/AdditionGamePage.dart';
import 'package:mind_maze/screens/game_addition_link/AdditionLinkGamePage.dart';
import 'package:mind_maze/screens/game_alpha_skip/AlphabetSkipGamePage.dart';
import 'package:mind_maze/screens/game_bird_watching/BirdWatching.dart';
import 'package:mind_maze/screens/game_card_calculations/CardCalculationsGamePage.dart';
import 'package:mind_maze/screens/game_color_deception/ColorDeceptionGamePage.dart';
import 'package:mind_maze/screens/game_ficker/flick_master.dart';
import 'package:mind_maze/screens/game_follow_leader/FollowTheLeader.dart';
import 'package:mind_maze/screens/game_highLow/HighLowGamePagev.dart';
import 'package:mind_maze/screens/game_matching/MatchingGamePage.dart';
import 'package:mind_maze/screens/game_operations/OperationsGamePage.dart';
import 'package:mind_maze/screens/game_quick_eye/QuickEyeGamePage.dart';
import 'package:mind_maze/screens/game_rapid_sorting/RapidSortingGamePage.dart';
import 'package:mind_maze/screens/game_simplicity/SimplicityGamePage.dart';
import 'package:mind_maze/screens/game_spinning_block/SpinningBlockGamePage.dart';
import 'package:mind_maze/screens/game_tap_color/TapColorGamePage.dart';
import 'package:mind_maze/screens/game_touch_number/TouchNumber.dart';
import 'package:mind_maze/screens/game_unfollow_leader/Unfollow_the_leader.dart';
import '../common/Key.dart';
import '../main.dart';

class TipsScreen extends StatefulWidget {
  GameModel gameModel;

  TipsScreen({required this.gameModel});

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  List unlockLevel = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    unlockLevel = session.read(KEY.KEY_Unlock) ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: box_decoration,
        child: Container(
          color: Colors.black.withOpacity(0.2),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          ClsSound.playSound(SOUNDTYPE.Tap);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SelectGameScreen()));
                        },
                        child: Image.asset('assets/Game/back.png', height: 30.r, width: 40.r, fit: BoxFit.fill),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(30.r, 5.r, 30.r, 5.r),
                        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/Game/btn_bg.png"), fit: BoxFit.fill)),
                        child: Text("LEVEL ${widget.gameModel.gameId}", style: TextStyle(color: txtColor, fontWeight: FontWeight.bold, fontSize: 25.r)),
                      ),
                      GestureDetector(
                        onTap: () {
                          ClsSound.playSound(SOUNDTYPE.Tap);
                          List favList = jsonDecode(session.read(KEY.KEY_Favourite) ?? '[]');
                          if (favList.contains(widget.gameModel.gameId)) {
                            favList.remove(widget.gameModel.gameId);
                          } else {
                            favList.add(widget.gameModel.gameId);
                          }
                          session.write(KEY.KEY_Favourite, jsonEncode(favList));
                          setState(() {});
                        },
                        child: Container(
                          width: 40.r,
                          height: 40.r,
                          decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/find_btn.png"), fit: BoxFit.fill),
                              borderRadius: BorderRadius.circular(5.r), color: Color(0xff273156)),
                          child: Center(
                            child: Image.asset((jsonDecode(session.read(KEY.KEY_Favourite) ?? '[]')).contains(widget.gameModel.gameId)
                                ? "assets/Game/heart_fill.png" : "assets/Game/heart_blank.png", height: 25.r, width: 25.r,
                                fit: BoxFit.fill, color: (jsonDecode(session.read(KEY.KEY_Favourite) ?? '[]')).contains(widget.gameModel.gameId)
                                    ? null : Colors.grey),
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
                          height: 430.r,
                          width: 350.r,
                          padding: EdgeInsets.all(10.r),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: 360.r,
                                  padding: EdgeInsets.symmetric(horizontal: 20.r),
                                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/Game/rect.png"), fit: BoxFit.fill)),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 3.r),
                                        Text(widget.gameModel.gameTitle.toUpperCase(), style: TextStyle(fontSize: 20.r, color: txtColor, letterSpacing: 1.r)),
                                        SizedBox(height: 3.r),
                                        Image.asset(widget.gameModel.Training_tips, height: 150.h),
                                        SizedBox(height: 2.r),
                                        Text(widget.gameModel.tipsText, textAlign: TextAlign.center, style: TextStyle(fontSize: 18.r, color: litetxtColor)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Image.asset("assets/Game/tip_icon.png", fit: BoxFit.fill, height: 100.r, width: 100.r),
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Image.asset("assets/Game/tip_brain.png", fit: BoxFit.fill, height: 60.r, width: 80.r),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.r),
                        InkWell(
                          onTap: () {
                            ClsSound.playSound(SOUNDTYPE.Tap);
                            if(widget.gameModel.isLock && !unlockLevel.contains(widget.gameModel.id.index)) {
                              if(!unlockLevel.contains(widget.gameModel.id.index)) {
                                unlockLevel.add(widget.gameModel.id.index);
                              }
                              session.write(KEY.KEY_Unlock, unlockLevel);
                              setState(() {});
                            }
                            switch (widget.gameModel.id) {
                              case Game.OPERATIONS:
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => OperationsGamePage(gameModel: widget.gameModel)));
                                break;
                              case Game.SIMPLICITY:
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => SimplicityGamePage(gameModel: widget.gameModel)));
                                break;
                              case Game.ColorOfDeception:
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => ColorDeceptionGamePage(gameModel: widget.gameModel)));
                                break;
                              case Game.FlickMaster:
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => FlickMaster(gameModel: widget.gameModel)));
                                break;
                              case Game.Addition:
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => AdditionGamePage(gameModel: widget.gameModel)));
                                break;
                              case Game.HighORLow:
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => HighLowGamePage(gameModel: widget.gameModel)));
                                break;
                              case Game.AdditionLink:
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => AdditionLinkGamePage(gameModel: widget.gameModel)));
                                break;
                              case Game.AlphabetSkip:
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => AlphabetSkipGamePage(gameModel: widget.gameModel)));
                                break;
                              case Game.BirdWatching:
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => BirdWatching(gameModel: widget.gameModel)));
                                break;
                              case Game.QuickEye:
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => QuickEyeGamePage(gameModel: widget.gameModel)));
                                break;
                              case Game.RapidSorting:
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => RapidSortingGamePage(gameModel: widget.gameModel)));
                                break;
                              case Game.SpinningBlock:
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => SpiningBlockGamePage(gameModel: widget.gameModel)));
                                break;
                              case Game.TapTheColor:
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => TapColorGamePage(gameModel: widget.gameModel)));
                                break;
                              case Game.CardCalculation:
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => CardCalCulationGamePage(gameModel: widget.gameModel)));
                                break;
                              case Game.FollowTheLeader:
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => FollowLeaderGamePage(gameModel: widget.gameModel)));
                                break;
                              case Game.UnfollowTheLeader:
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => UnfollowLeaderGamePage(gameModel: widget.gameModel)));
                                break;
                              case Game.TouchNumber:
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => TouchNumberGamePage(gameModel: widget.gameModel)));
                                break;
                              case Game.Matching:
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => MatchingGamePage(gameModel: widget.gameModel)));
                                break;
                              case Game.FindQuest:
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => FindQuestScreen(gameModel: widget.gameModel)));
                                break;
                              case Game.ChromaShapes:
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => ChromaShapesScreen(gameModel: widget.gameModel)));
                                break;
                              case Game.ColorSense:
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => ColorSenseScreen(gameModel: widget.gameModel)));
                                break;
                              case Game.NumberSorter:
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => NumberSorterScreen(gameModel: widget.gameModel)));
                                break;
                              case Game.PicMatch:
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => PicMatchScreen(gameModel: widget.gameModel)));
                                break;
                              case Game.StopTheBall:
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => StopTheBallGameScreen(gameModel: widget.gameModel)));
                                break;
                              case Game.ColorQuest:
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => ColorQuestScreen(gameModel: widget.gameModel)));
                                break;
                              case Game.ShapesQuest:
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => ShapesQuestScreen(gameModel: widget.gameModel)));
                                break;
                              case Game.VisualMastery:
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => VisualMasteryScreen(gameModel: widget.gameModel)));
                                break;
                            }
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: widget.gameModel.isLock && !unlockLevel.contains(widget.gameModel.id.index)
                                ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.lock, size: 35.r, color: txtColor.withOpacity(0.8)),
                                SizedBox(width: 8.w),
                                Text("Unlock", style: TextStyle(color: txtColor.withOpacity(0.8), fontSize: 25.r)),
                              ],
                            )
                                : Text("TAP TO START !", style: TextStyle(fontSize: 25.r, color: txtColor.withOpacity(0.8))),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    "- Pay attention.\n- With 100% accuracy, You wll get 2x points.\n- You will get ${widget.gameModel.playTimeSec} sec, Be Prepared.",
                    style: TextStyle(color: litetxtColor, fontSize: 14.sp),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
