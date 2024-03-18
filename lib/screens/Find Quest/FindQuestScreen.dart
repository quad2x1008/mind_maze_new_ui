import 'dart:async';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mind_maze/main.dart';
import 'package:mind_maze/screens/GameModel.dart';
import 'package:mind_maze/screens/TimerTitle.dart';
import 'package:mind_maze/screens/TipsScreen.dart';
import 'package:mind_maze/screens/game_operations/LiveScorePoint.dart';
import 'package:quiver/async.dart';
import 'package:vibration/vibration.dart';
import '../../common/ClsSound.dart';
import '../../common/Common.dart';
import '../../common/Key.dart';
import '../../constants.dart';
import '../ResultPage.dart';

class FindQuestScreen extends StatefulWidget {
  GameModel gameModel;

  FindQuestScreen({required this.gameModel});

  @override
  State<FindQuestScreen> createState() => _FindQuestScreenState();
}

class _FindQuestScreenState extends State<FindQuestScreen> with TickerProviderStateMixin {
  List num1 = ["8", "Q", "B", "7", "😀", "😛", "😕", "🙂", "👩‍🎓", "☺", "🤩", "😎", "😒"];
  List num2 = ["3", "0", "8", "1", "😄", "😝", "😟", "🙃", "👨‍🎓", "😊", "😍", "🤓", "😏"];
  late String nums1, nums2;
  int num = 0;
  List numList = [];
  Random random = Random();
  bool isWrong = true;
  bool isRight = true;
  bool clickStatus = true;
  int? selectedIndex;

  late AnimationController _animationController;
  bool isAnimation = false, isStart = true, isWrong1 = true;
  Timer? timer;
  int correct = 0;
  int incorrect = 0;
  int _current = 30;
  int count = 0;

  Future<void> initGame() async {
    isWrong = false;
    isRight = false;
    clickStatus = true;
    selectedIndex = null;
    num = random.nextInt(num1.length);
    nums1 = num1[num];
    nums2 = num2[num];
    numList.shuffle();
    numList = List.filled(84, nums1);
    print("nums1 = $nums1, nums2 = $nums2");

    while (true) {
      nums2 = num2[num];
      if (nums1 != nums2) {
        do {
          num = random.nextInt(numList.length);
        } while (numList[num] == nums2);
        print("k[nums1] = $nums1 & j[nums2] = $nums2");
        numList[num] = nums2;
        break;
      }
    }

    setState(() {});
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
                        width: 0.45.sh,
                        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/Game/big_rect.png"), fit: BoxFit.fill)),
                        padding: EdgeInsets.all(15.r),
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: 84,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () async {
                                  ClsSound.playSound(SOUNDTYPE.Tap);
                                  if (clickStatus) {
                                    clickStatus = false;
                                    if (numList[index] == nums2) {
                                      print("correct");
                                      isRight = true;
                                      selectedIndex = index;
                                      getCardColor(index);
                                      initGame();
                                      setState(() {
                                        print("==> correct ${correct++}");
                                        ClsSound.playSound(SOUNDTYPE.Correct);
                                      });
                                      setState(() {});
                                    } else {
                                      print('incorrect');
                                      isWrong = true;
                                      isWrong1 = false;
                                      selectedIndex = index;
                                      getCardColor(index);
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
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(6.r), color: getCardColor(index), image: DecorationImage(image: AssetImage("assets/Game/find_btn.png"), fit: BoxFit.fill)),
                                  child: Center(child: Text("${numList[index]}", style: TextStyle(color: txtColor, fontSize: 22.r))),
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

  getCardColor(index) {
    if (isWrong) {
      if (selectedIndex == index) {
        return Colors.red;
      }
      if (nums2 == numList[index]) {
        return Colors.green;
      }
    }
    if (isRight) {
      if (selectedIndex == index) {
        return Colors.green;
      }
    }
    return litetxtColor;
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
    temp.add(gameModelList[19].gameId);
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
              return TipsScreen(gameModel: gameModelList[19]);
            }));
          },
        )));
  }
}
