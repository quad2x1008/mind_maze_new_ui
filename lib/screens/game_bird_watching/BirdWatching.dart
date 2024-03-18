import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mind_maze/main.dart';
import 'package:mind_maze/screens/GameModel.dart';
import 'package:mind_maze/screens/TipsScreen.dart';
import 'package:quiver/async.dart';
import 'package:vibration/vibration.dart';
import '../../common/ClsSound.dart';
import '../../common/Common.dart';
import '../../common/Key.dart';
import '../../constants.dart';
import '../ResultPage.dart';
import '../TimerTitle.dart';
import '../game_operations/LiveScorePoint.dart';

class BirdWatching extends StatefulWidget {
  GameModel gameModel;

  BirdWatching({required this.gameModel});

  @override
  State<BirdWatching> createState() => _BirdWatchingState();
}

class _BirdWatchingState extends State<BirdWatching> with TickerProviderStateMixin {
  final _random = Random();
  int ON_Tap = 0;

  bool is_visible_margin = true;
  EdgeInsets margin_3x3 = EdgeInsets.fromLTRB(50, 0, 50, 0);
  EdgeInsets margin_4x4 = EdgeInsets.fromLTRB(25, 0, 25, 0);

  int? time;
  int correct = 0;
  int incorrect = 0;
  List<Color> currentColor = [];
  bool isWrong = true;
  bool isDone = true;
  int selected = 0;

  List<Color> colors = [
    Color(0xfffdcf15),
    Color(0xfff82b2b),
    Color(0xff0176fc),
    Color(0xff12a603),
    Color(0xffe17319),
  ];

  @override
  void initState() {
    initGame();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationController.repeat(reverse: true);
    super.initState();
  }

  late AnimationController _animationController;

  int _current = 30;

  bool isAnimation = false, isStart = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        ClsSound.playSound(SOUNDTYPE.Tap);
        countDownTimer?.cancel();
        ClsSound.stopTikTik();
        _animationController.stop();
        return backButton(context);
      },
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: box_decoration,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            actions: [
              LiveScorePoint(correct,incorrect,_current,widget.gameModel.playTimeSec),
            ],
            title: TimerTitle(_current),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(
              child: InkWell(
                onTap: () {
                  ClsSound.playSound(SOUNDTYPE.Tap);
                  countDownTimer?.cancel();
                  ClsSound.stopTikTik();
                  _animationController?.dispose();
                  backButton(context);
                },
                child: Icon(Icons.chevron_left, size: 30.r, color: primaryColor),
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: isStart?Container(
                  alignment: Alignment.center,
                  child: DefaultTextStyle(
                    style: TextStyle(fontSize: 70.0.sp, color: white),
                    child: AnimatedTextKit(
                      isRepeatingAnimation: false,
                      onFinished: () {
                        setState(() {
                          isStart = false;
                          startTime();
                        });
                      },
                      animatedTexts: [
                        ScaleAnimatedText('3',duration: 500.ms),
                        ScaleAnimatedText('2',duration: 500.ms),
                        ScaleAnimatedText('1',duration: 500.ms),
                      ],
                    ),
                  ),
                ):Stack(
                  children: [
                    Visibility(
                      visible: !isWrong,
                        child: Stack(
                          children: [
                            Container(
                              width: 35.w,
                              alignment: Alignment.topLeft,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [red75, red60, red45, red30, red15, Colors.transparent],
                                  begin: Alignment.topLeft,
                                  end: Alignment.topRight,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                width: 35.w,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [red75, red60, red45, red30, red15, Colors.transparent],
                                    begin: Alignment.topRight,
                                    end: Alignment.topLeft,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 35.h,
                              alignment: Alignment.topCenter,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [red75, red60, red45, red30, red15, Colors.transparent],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 35.h,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [red75, red60, red45, red30, red15, Colors.transparent],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: isAnimation,
                        child: FadeTransition(
                          opacity: _animationController,
                          child: Container(
                            height: 80.0,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [red75, red60, red45, red30, red15, Colors.transparent],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              transformAlignment: Alignment.center,
                              margin: is_visible_margin ? margin_3x3 : margin_4x4,
                              child: StaggeredGrid.count(
                                crossAxisCount: gridSize,
                                mainAxisSpacing: 6.5,
                                crossAxisSpacing: 6.5,
                                children: List.generate(currentColor.length, (index) {
                                  var item = currentColor[index];
                                  return colorBox(item, index);
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }

  colorBox(Color item, int index) {
    return GestureDetector(
      onTap: () async {
        ClsSound.playSound(SOUNDTYPE.Tap);
        selected = index;
        if (item == ansColors) {
          ON_Tap++;
          print("==> correct ${correct++}");
          ClsSound.playSound(SOUNDTYPE.Correct);
          initGame();
        } else {
          print("==> incorrect ${incorrect++}");
          Vibration.vibrate(duration: 400);
          setState(() {
            isWrong = !isWrong;
          });
          Future.delayed(200.ms, () {
            isWrong = !isWrong;
            setState(() {});
          });
        }
        if (ON_Tap == 5) {
          print("Tap == ${ON_Tap}");
          setState(() {
            gridSize = 4;
            initGame();
            isDone = !isDone;
            is_visible_margin = false;
          });
        }
        setState(() {});
      },
      child: isWrong ? Container(
        height: 70.h,
        width: 70.h,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), color: item),
      ).animate(target: isDone ? 1 : 0).shimmer(duration: 200.ms).shake(hz: 2, curve: Curves.easeInOutCubic)
          : Container(
        height: 70.h,
        width: 70.h,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), color: item),
      ).animate(target: selected != index ? 1 : 0).shake(hz: 8, curve: Curves.easeInOutCubic).scale(begin: Offset(1, 1), end: Offset(0.9, 0.9)),
    );
  }

  int gridSize = 3;
  Map<Color, int> colorCount = {};
  Color ansColors = white;

  initGame() {
    currentColor = [];
    colorCount = {};

    for (int i = 0; i < (gridSize * gridSize); i++) {
      Color color;
      if (gridSize == 3) {
        color = colors[_random.nextInt(4)];
      } else
        color = colors[_random.nextInt(colors.length)];
      currentColor.add(color);
      colorCount[color] = (colorCount[color] ?? 0) + 1;
    }

    int thevalue = 0;

    colorCount.forEach((k, v) {
      if (v > thevalue) {
        thevalue = v;
        ansColors = k;
      }
    });
    List<Color> duplicate = [];
    colorCount.forEach((key, value) {
      if (value == thevalue && key != ansColors) {
        duplicate.add(key);
      }
    });

    duplicate.forEach((element) {
      int index = currentColor.indexOf(element);
      currentColor[index] = Colors.deepPurpleAccent;
    });
    currentColor.shuffle();
    print(colorCount);
    print(colorCount[ansColors]);

    Future.delayed(200.ms, () {
      isDone = !isDone;
      setState(() {});
    });
  }

  @override
  void dispose() {
    countDownTimer?.cancel();
    ClsSound.stopTikTik();
    _animationController.stop();
    super.dispose();
  }

  CountdownTimer? countDownTimer;

  startTime() async {
    countDownTimer = CountdownTimer(
      Duration(seconds: widget.gameModel.playTimeSec),
      Duration(seconds: 1),
    );

    var sub = countDownTimer!.listen(null);
    sub.onData((duration) {
      setState(() {
        _current = widget.gameModel.playTimeSec - duration.elapsed.inSeconds;

        if (_current == 6) {
          ClsSound.playTikTik();
        }
        if (_current < 6) {
          isAnimation = true;
        }
      });
    });

    sub.onDone(() {
      ResultInfo resultInfo = ResultInfo(no_of_que: correct + incorrect, correct: correct, incorrect: incorrect);
      sub.cancel();
      goTo(resultInfo);
    });
  }

  goTo(ResultInfo resultInfo) {
    List temp = (session.read(KEY.KEY_Unlock) ?? [1]);
    temp.add(gameModelList[9].gameId);
    session.write(KEY.KEY_Unlock, temp);

    int sum = (session.read(KEY.KEY_TotalCompleteLevel) ?? 0) + 1;
    session.write(KEY.KEY_TotalCompleteLevel, sum);

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
        ResultPage(
          resultInfo: resultInfo,
          gameModel: widget.gameModel,
          nextLevelTap: () {
            session.write(KEY.KEY_Timer, 0);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              return TipsScreen(gameModel: gameModelList[9]);
            }));
          },
        )));
  }
}
