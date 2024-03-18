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

class ColorQuestScreen extends StatefulWidget {
  GameModel gameModel;

  ColorQuestScreen({required this.gameModel});

  @override
  State<ColorQuestScreen> createState() => _ColorQuestScreenState();
}

class _ColorQuestScreenState extends State<ColorQuestScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool isAnimation = false, isStart = true, isWrong1 = true;
  Timer? timer1;
  int correct = 0;
  int incorrect = 0;
  int _current = 30;
  int count = 0;

  List num1 = [
    Colors.pink,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.teal,
    Colors.cyan,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.brown,
  ];
  List num2 = [
    Colors.pink.shade600,
    Colors.red.shade600,
    Colors.orange.shade600,
    Colors.yellow.shade600,
    Colors.green.shade600,
    Colors.teal.shade600,
    Colors.cyan.shade600,
    Colors.blue.shade600,
    Colors.indigo.shade600,
    Colors.purple.shade600,
    Colors.brown.shade600,
  ];
  late String nums1, nums2;
  int num = 0;
  List numList = [];
  Random random = Random();
  bool isWrong = true;
  bool isRight = true;
  int? selectedIndex;
  bool timer = false;
  bool clickStatus = true;

  Future<void> initGame() async {
    timer = true;
    clickStatus = true;
    isRight = false;
    isWrong = false;
    selectedIndex = null;
    num = random.nextInt(num1.length);
    nums1 = num1[num].value.toRadixString(16);
    nums2 = num2[num].value.toRadixString(16);
    numList.shuffle();
    numList = List.filled(30, nums1);
    print("nums1 = $nums1, nums2 = $nums2");

    while (true) {
      nums2 = num2[num].value.toRadixString(16);
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
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: Container(
                        width: 0.60.sh,
                        height: 0.80.sh,
                        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/Game/big_rect.png"), fit: BoxFit.fill)),
                        padding: EdgeInsets.all(15.r),
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: 30,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            mainAxisExtent: 85,
                          ),
                          itemBuilder: (context, index) {
                            Color color = Color(int.parse(numList[index], radix: 16));
                            return GestureDetector(
                              onTap: () async {
                                ClsSound.playSound(SOUNDTYPE.Tap);
                                if (clickStatus) {
                                  clickStatus = false;
                                  if (color == Color(int.parse(nums2, radix: 16))) {
                                    print("correct");
                                    isRight = true;
                                    initGame();
                                    setState(() {
                                      print("==> correct ${correct++}");
                                      ClsSound.playSound(SOUNDTYPE.Correct);
                                    });
                                  } else {
                                    print('incorrect');
                                    isWrong = true;
                                    isWrong1 = false;
                                    initGame();
                                    print("==> incorrect ${incorrect++}");
                                    Vibration.vibrate(duration: 300);
                                    Future.delayed(200.ms, () {
                                      isWrong1 = !isWrong1;
                                      setState(() {});
                                    });
                                  }
                                }
                                setState(() {});
                              },
                              child: Container(
                                margin: EdgeInsets.all(2.r),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.r),
                                  color: color,
                                ),
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
    temp.add(gameModelList[25].gameId);
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
                return TipsScreen(gameModel: gameModelList[25]);
              }));
          },
        )));
  }
}
