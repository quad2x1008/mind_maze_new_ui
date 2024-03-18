import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
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

var listShapes = [
  "assets/Game/circle.png",
  "assets/Game/heart.png",
  "assets/Game/square.png",
  "assets/Game/star.png",
  "assets/Game/triangle.png",
];

class RapidSortingGamePage extends StatefulWidget {
  GameModel gameModel;

  RapidSortingGamePage({required this.gameModel});

  @override
  State<RapidSortingGamePage> createState() => _RapidSortingGamePageState();
}

class _RapidSortingGamePageState extends State<RapidSortingGamePage> with TickerProviderStateMixin {
  String oldShape = listShapes[Random().nextInt(listShapes.length)];
  String currentShape = listShapes[Random().nextInt(listShapes.length)];
  bool isNew = true;
  bool isStart = true;
  bool isUp = true;
  bool isDown = true;
  bool isWrong = true;
  int correct = 0;
  int incorrect = 0;
  int _current = 30;

  late AnimationController _animationController;
  bool isAnimation = false, isStart1 = true;
  String pervSide = "right";
  bool isDetact = false;
  int num1 = Random().nextInt(4);
  List<Widget> listCard = [];
  List<String> shapeList = [];
  final CardSwiperController controller = CardSwiperController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationController.repeat(reverse: true);
  }

  initGame() {
    for (int i = 0; i < 100; i++) {
      if (num1 <= 0) {
        currentShape = listShapes[Random().nextInt(listShapes.length)];
        if (shapeList.isEmpty) {
          if (currentShape == oldShape) {
            do {
              currentShape = listShapes[Random().nextInt(listShapes.length)];
            } while (currentShape == oldShape);
          }
        } else {
          if (currentShape == shapeList[i - 1]) {
            do {
              currentShape = listShapes[Random().nextInt(listShapes.length)];
            } while (currentShape == shapeList[i - 1]);
          }
        }
        num1 = Random().nextInt(4);
        listCard.add(card(currentShape));
        shapeList.add(currentShape);
      } else {
        listCard.add(card(currentShape));
        shapeList.add(currentShape);
        num1--;
      }
      print("${shapeList.length}, ${listCard.length}, $i = $currentShape");
    }

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isNew = false;
        shapeList.add(oldShape);
      });
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
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
            title: TimerTitle(_current),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              LiveScorePoint(correct, incorrect, _current, widget.gameModel.playTimeSec),
            ],
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
                child: isStart1 ? Container(
                  alignment: Alignment.center,
                  child: DefaultTextStyle(
                    style: TextStyle(fontSize: 70.0.sp, color: white),
                    child: AnimatedTextKit(
                      isRepeatingAnimation: false,
                      onFinished: () {
                        setState(() {
                          isStart1 = false;
                          startTime();
                          initGame();
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
                                decoration: BoxDecoration(gradient: LinearGradient(colors: [red75, red60, red45, red30, red15, Colors.transparent], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
                              ),
                            )
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
                      isNew ? Container(
                        alignment: Alignment.center,
                          child: Card(
                            color: bgColor,
                            elevation: 6,
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(20),
                              height: 120.h,
                              width: 120.h,
                              child: Image.asset(oldShape),
                            ),
                          ),
                      ).animate(target: isStart ? 1 : 0).slideY(duration: 200.ms, begin: -1, end: 0).slideX(delay: 1500.ms, duration: 200.ms, begin: 0, end: 1)
                          : CardSwiper(
                        controller: controller,
                        scale: 0.2,
                        maxAngle: 20,
                        duration: 200.ms,
                        isLoop: true,
                        onSwipe: _swipe,
                        isDisabled: !isWrong,
                        padding: const EdgeInsets.all(24.0),
                        cardsCount: listCard.length,
                        cardBuilder: (context, index, horizontalThresholdPercentage, verticalThresholdPercentage) => listCard[index],
                      ).animate(target: isStart ? 1 : 0).slide(begin: Offset(0.25, -1), end: Offset(0.25, 0.35))
                          .animate(target: isWrong ? 1 : 0).shake(hz: 8, curve: Curves.easeInOutCubic),
                    ],
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }

  bool _swipe(int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    debugPrint('The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top');
    checkAns(direction.name, previousIndex);
    return true;
  }

  Widget card(String currentShape) {
    return Card(
      color: white,
      elevation: 6,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        height: 120.h,
        width: 120.h,
        child: Image.asset(currentShape),
      ),
    );
  }

  void checkAns(String currSlide, int index) {
    print(currSlide);

    if(pervSide==""||(shapeList[index + 1] == shapeList[index] && pervSide==currSlide)||(shapeList[index + 1] != shapeList[index] && pervSide!=currSlide)){
      print('num=1 = ${shapeList[index + 1]} , num2 = ${shapeList[index]} $currSlide $pervSide $index ${index + 1}');
      setState(() {
        correct++;
        ClsSound.playSound(SOUNDTYPE.Correct);
        pervSide = currSlide;
      });
    }
    else {
      print('num=5 = ${shapeList[index + 1]} , num2 = ${shapeList[index]} $currSlide $pervSide $index ${index + 1}');
      pervSide = "";
      setState(() {
        isWrong = false;
        incorrect++;
        Vibration.vibrate(duration: 300);
      });
      Future.delayed(200.ms, () {
        changeWrong();
        setState(() {});
      });
      print('Wrong');
    }
  }

  void getnewShape() {
    setState(() {
      isStart = false;
    });
    Future.delayed(200.ms, () {
      setState(() {
        isStart = true;
      });
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
      route(resultInfo);
    });
  }

  route(ResultInfo resultInfo) {
    List temp = (session.read(KEY.KEY_Unlock) ?? [1]);
    temp.add(gameModelList[11].gameId);
    session.write(KEY.KEY_Unlock, temp);

    int sum = (session.read(KEY.KEY_TotalCompleteLevel) ?? 0) + 1;
    session.write(KEY.KEY_TotalCompleteLevel, sum);

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) =>
        ResultPage(
          resultInfo: resultInfo,
          gameModel: widget.gameModel,
          nextLevelTap: () {
            session.write(KEY.KEY_Timer, 0);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              return TipsScreen(gameModel: gameModelList[11]);
            }));
          },
        )));
  }

  changeDown() {
    isDown = !isDown;
  }

  changeWrong() {
    isWrong = !isWrong;
  }
}
