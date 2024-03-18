import 'dart:async';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

class ShapesQuestScreen extends StatefulWidget {
  GameModel gameModel;

  ShapesQuestScreen({required this.gameModel});

  @override
  State<ShapesQuestScreen> createState() => _ShapesQuestScreenState();
}

class _ShapesQuestScreenState extends State<ShapesQuestScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool isAnimation = false, isStart = true, isWrong1 = true;
  Timer? timer;
  int correct = 0;
  int incorrect = 0;
  int _current = 30;
  int count = 0;

  int? selectedIndex;
  bool isWrong = true;
  String win = "";
  static var level = 1;
  static var level1 = 1;
  int cnt = 0;
  int num = 4;
  bool clickStatus = true;
  int number = 1;
  List<bool> selectedIndices = [false, false, false, false];

  List get = [1, 2, 3, 4];
  List<String> imagePaths = [];
  late String imagePath;

  Future<void> initGame() async {
    setState(() {});
    clickStatus = true;
    update();
    get.shuffle();
    updateImage();
  }

  void updateImage() {
    setState(() {
      imagePaths.clear();
      level = Random().nextInt(3) + 1;
      level1 = Random().nextInt(3) + 1;

      for (int i = 0; i < get.length; i++) {
        imagePath = "assets/Game/images/level55_r${level}_i${level1}_${get[i]}.png";
        imagePaths.add(imagePath);
        if (get[i] == 4) {
          num = i;
        }
      }
    });
  }

  void update() {
    setState(() {
      if (level1 == 3) {
        level++;
        level1 = 1;
      } else {
        level1++;
      }

      if (level > 3) {
        level = 1;
        level1 = 1;
        moveToNextLevel();
      }
    });
    updateImage();
  }

  void moveToNextLevel() {
    setState(() {
      level1++;
      if (level1 > 3) {
        level1 = 1;
        level++;
        if (level > 3) {
          level = 1;
        }
      }
      win = "";
      cnt = 0;
      get.shuffle();
      updateImage();
    });
  }

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
              LiveScorePoint(correct, incorrect, _current, widget.gameModel.playTimeSec),
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
                child: isStart ? Container(
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
                        ScaleAnimatedText('3', duration: 500.ms),
                        ScaleAnimatedText('2', duration: 500.ms),
                        ScaleAnimatedText('1', duration: 500.ms),
                      ],
                    ),
                  ),
                ) : Stack(
                  children: [
                    Visibility(
                      visible: !isWrong1,
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
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(20.r),
                      child: Container(
                        width: 0.50.sh,
                        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/Game/big_rect.png"), fit: BoxFit.fill)),
                        padding: EdgeInsets.all(15.r),
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: 4,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () async {
                                  ClsSound.playSound(SOUNDTYPE.Tap);
                                  if (clickStatus) {
                                    clickStatus = false;
                                    if (num == index) {
                                      win = "you win!!";
                                      print("correct");
                                      if (win == "you win!!") {
                                        win = "";
                                        cnt = 0;
                                        initGame();
                                        number++;
                                        setState(() {
                                          print("==> correct ${correct++}");
                                          ClsSound.playSound(SOUNDTYPE.Correct);
                                        });
                                      }
                                      selectedIndex = index;
                                    } else {
                                      win = "wrong!!";
                                      print('incorrect');
                                      isWrong = true;
                                      selectedIndex = index;
                                      selectedIndices[index] = true;
                                      isWrong1 = false;
                                      initGame();
                                      print("==> incorrect ${incorrect++}");
                                      Vibration.vibrate(duration: 300);
                                      Future.delayed(200.ms, () {
                                        isWrong1 = !isWrong1;
                                        setState(() {});
                                      });
                                    }
                                    setState(() {});
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.all(2.r),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: litetxtColor,
                                    image: DecorationImage(image: AssetImage("assets/Game/find_btn.png"), fit: BoxFit.fill)),
                                  child: Center(child: Image.asset(imagePaths[index], height: 80, width: 80)),
                                ),
                            );
                          },
                        ),
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

  CountdownTimer? countDownTimer;

  @override
  void initState() {
    super.initState();
    initGame();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationController.repeat(reverse: true);
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    countDownTimer?.cancel();
    ClsSound.stopTikTik();
    _animationController.stop();
    super.dispose();
  }

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
        if(_current < 6) {
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
    temp.add(gameModelList[26].gameId);
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
                return TipsScreen(gameModel: gameModelList[26]);
              }));
          },
        )));
  }
}
