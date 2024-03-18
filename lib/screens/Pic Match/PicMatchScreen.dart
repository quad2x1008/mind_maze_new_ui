import 'dart:async';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
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

class PicMatchScreen extends StatefulWidget {
  GameModel gameModel;

  PicMatchScreen({required this.gameModel});

  @override
  State<PicMatchScreen> createState() => _PicMatchScreenState();
}

class _PicMatchScreenState extends State<PicMatchScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool isAnimation = false, isStart = true, isWrong = true;
  Timer? timer;
  int correct = 0;
  int incorrect = 0;
  int _current = 30;
  int count = 0;

  List<FlipCardController> conrtollerList = [];
  int cardone = -1;
  bool cardstatus = true;
  List<bool> checkList = List.filled(20, false);

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
                    Container(
                        height: 1.sh,
                        padding: EdgeInsets.only(left: 15.r, right: 15.r, top: 1.r, bottom: 1.r),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: imageFinalList.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 0.75.r),
                          itemBuilder: (context, index) {
                            return FlipCard(
                              controller: conrtollerList[index],
                              fill: Fill.fillBack,
                              flipOnTouch: false,
                              autoFlipDuration: Duration(seconds: 3),
                              direction: FlipDirection.HORIZONTAL,
                              side: CardSide.FRONT,
                              front: Container(
                                decoration: const BoxDecoration(
                                  image: DecorationImage(image: AssetImage("assets/Game/fcard.png"), fit: BoxFit.fill),
                                ),
                                child: Center(
                                  child: Container(
                                    height: 50.r,
                                    width: 50.r,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(image: AssetImage("assets/Game/Pic_Match/${imageFinalList[index]}.png"), fit: BoxFit.fill),
                                    ),
                                  ),
                                ),
                              ),
                              back: GestureDetector(
                                onTap: () async {
                                  ClsSound.playSound(SOUNDTYPE.Tap);
                                  if (cardstatus && index != cardone) {
                                    if (cardone != -1) {
                                      cardstatus = false;
                                      int tempcard = cardone.toInt();
                                      cardone = -1;
                                      conrtollerList[index].toggleCard();
                                      if (imageFinalList[tempcard] == imageFinalList[index]) {
                                        checkList[tempcard] = true;
                                        checkList[index] = true;
                                        cardstatus = true;
                                        setState(() {
                                          print("==> correct ${correct++}");
                                          ClsSound.playSound(SOUNDTYPE.Correct);
                                        });
                                        if (!checkList.contains(false)) {
                                          print("Complete");
                                          ResultInfo resultInfo = ResultInfo(no_of_que: correct + incorrect, correct: correct, incorrect: incorrect);
                                          goTo(resultInfo);
                                        }
                                      } else {
                                        Future.delayed(Duration(seconds: 1), () {
                                          conrtollerList[tempcard].toggleCard();
                                          conrtollerList[index].toggleCard();
                                          cardstatus = true;
                                          isWrong = false;
                                          print("==> incorrect ${incorrect++}");
                                          Vibration.vibrate(duration: 300);
                                          Future.delayed(200.ms, () {
                                            isWrong = !isWrong;
                                            setState(() {});
                                          });
                                        });
                                      }
                                    } else {
                                      cardone = index;
                                      conrtollerList[index].toggleCard();
                                    }
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.all(1.r),
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(image: AssetImage("assets/Game/bcard.png"), fit: BoxFit.fill),
                                  ),
                                ),
                              ),
                            );
                          },
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

  List<int> imageList1 = [];
  List<int> imageList2 = [];
  List<int> imageFinalList = [];

  initGame() {
    imageList1 = [];
    imageList2 = [];
    imageFinalList = [];
    conrtollerList = [];
    checkList = List.filled(20, false);
    cardstatus = true;
    cardone = -1;
    while (true) {
      int r = Random().nextInt(30);
      if (imageList1.length < 10) {
        if (!imageList1.contains(r) && r != 0) {
          imageList1.add(r);
        }
      } else {
        break;
      }
    }
    for (int i = 0; i < 20; i++) {
      conrtollerList.add(FlipCardController());
    }
    imageList2 = imageList1;
    imageFinalList = imageList1 + imageList2;
    imageFinalList.shuffle();
    print(imageFinalList);
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
    temp.add(gameModelList[23].gameId);
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
                return TipsScreen(gameModel: gameModelList[23]);
              }));
          },
        )));
  }
}
