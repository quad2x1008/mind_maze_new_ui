import 'dart:async';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:linear_timer/linear_timer.dart';
import 'package:mind_maze/screens/GameModel.dart';
import 'package:quiver/async.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:vibration/vibration.dart';
import '../../common/ClsSound.dart';
import '../../common/Common.dart';
import '../../common/Key.dart';
import '../../constants.dart';
import '../../main.dart';
import '../ResultPage.dart';
import '../TimerTitle.dart';
import '../game_operations/LiveScorePoint.dart';

class VisualMasteryScreen extends StatefulWidget {
  GameModel gameModel;

  VisualMasteryScreen({required this.gameModel});

  @override
  State<VisualMasteryScreen> createState() => _VisualMasteryScreenState();
}

class _VisualMasteryScreenState extends State<VisualMasteryScreen> with TickerProviderStateMixin {
  int slideradd = 0;
  bool slidercon = false;
  List<String> list = [
    "assets/Game/Count_Quest/1.png",
    "assets/Game/Count_Quest/2.png",
    "assets/Game/Count_Quest/3.png",
    "assets/Game/Count_Quest/4.png",
    "assets/Game/Count_Quest/5.png"
  ];
  Random random = Random();
  int num = 0, number = 0;
  bool timer = false;
  bool isStart = true, isEnd = true, isWrong = true;
  LinearTimerController? timerControllerHome;
  bool isAnimating = true;
  double leftPosition = -250.0;
  ItemScrollController itemScrollController = ItemScrollController();
  List imagenumber = [];
  Map<String, int> imageCounts = {};

  void updateImageCount(String imagePath) {
    if(imageCounts.containsKey(imagePath)) {
      imageCounts[imagePath] = imageCounts[imagePath]! + 1;
    } else {
      imageCounts[imagePath] = 1;
    }
    print(imageCounts);
  }

  void initGame() {
    timer = true;
    for(int i = 0; i < 10; i++) {
      num = random.nextInt(list.length);
      imagenumber.add(num);
      list.shuffle();
    }
  }

  Timer? imageChangeTimer;
  Timer? sliderin;

  @override
  void initState() {
    Timer(Duration(seconds: 1), () {
      slidercon = true;
    });
    // TODO: implement initState
    super.initState();
    initGame();

    imageChangeTimer = Timer.periodic(Duration(milliseconds: 1300), (timer) {
      if(mounted) {
        setState(() {
          if(number <= 10) {
            updateImageCount(list[imagenumber[number]]);
            number++;
          }
          if(number == 10) {
            imageCounts.forEach((imagePath, count) {});
            imageChangeTimer?.cancel();
          }
        });
      }
    });

    sliderin = Timer.periodic(Duration(milliseconds: 1200), (timer) {
      if(mounted) {
        setState(() {
          if(slideradd < 10) {
            slideradd++;
            itemScrollController.scrollTo(index: slideradd, duration: Duration(milliseconds: 200));
          } else {
            sliderin!.cancel();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        timerControllerHome?.dispose();
        EasyLoading.dismiss();
        return backButton(context);
      },
      child: Scaffold(
        body: Container(
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
                            timerControllerHome?.dispose();
                            EasyLoading.dismiss();
                            backButton(context);
                          },
                          child: Image.asset("assets/Game/back.png", height: 20.r, width: 30.r, fit: BoxFit.fill),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(30.r, 5.r, 30.r, 5.r),
                          decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/Game/btn_bg.png"), fit: BoxFit.fill)),
                          child: Text("COUNT QUEST", style: TextStyle(color: txtColor, fontWeight: FontWeight.bold, fontSize: 22.r)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.r),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: timer,
                          child: LinearTimer(
                            controller: timerControllerHome,
                            forward: true,
                            duration: Duration(seconds: 10),
                            color: txtColor,
                            backgroundColor: litetxtColor,
                            minHeight: 10,
                            onTimerStart: () {
                              print("onTimerStart ${DateTime.now()}");
                            },
                            onTimerEnd: () {
                              print("Timer ended");
                              print("onTimerEnd ${DateTime.now()}");
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CountScreen(imageCounts: imageCounts, gameModel: widget.gameModel)));
                            },
                          ),
                        ),
                        SizedBox(height: 20.r),
                        Container(
                          height: 500.h,
                          width: 400.w,
                          child: Container(
                            height: 400.h,
                            width: 1.sw,
                            margin: EdgeInsets.symmetric(horizontal: 20.r),
                            padding: EdgeInsets.symmetric(horizontal: 20.r),
                            decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/Game/big_rect.png"), fit: BoxFit.fill)),
                            child: ScrollablePositionedList.builder(
                              scrollDirection: Axis.horizontal,
                              itemScrollController: itemScrollController,
                              initialScrollIndex: slideradd,
                              itemCount: imagenumber.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Center(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 20.r),
                                    height: 250.h,
                                    width: 250.w,
                                    decoration: BoxDecoration(image: DecorationImage(image: AssetImage(list[imagenumber[index]]))),
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
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class CountScreen extends StatefulWidget {
  GameModel gameModel;
  final Map<String, int> imageCounts;

  CountScreen({Key? key, required this.imageCounts, required this.gameModel}) : super(key: key);

  @override
  State<CountScreen> createState() => _CountScreenState();
}

class _CountScreenState extends State<CountScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool isAnimation = false, isWrong1 = true, isStart1 = true;
  Timer? timer1;
  int correct = 0;
  int incorrect = 0;
  int _current = 30;
  int count = 0;

  List<String> numList = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "X", "0", "✔"];
  var userInput = '';
  List<String> listImage = [
    "assets/Game/Count_Quest/1.png",
    "assets/Game/Count_Quest/2.png",
    "assets/Game/Count_Quest/3.png",
    "assets/Game/Count_Quest/4.png",
    "assets/Game/Count_Quest/5.png"
  ];
  Random random = Random();
  int num = -1;
  bool timer = false;
  bool clickStatus = true;

  void initGame() {
    timer = true;
    clickStatus = true;
    num = random.nextInt(listImage.length);
    listImage.shuffle();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initGame();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    int count = widget.imageCounts[listImage[num]] ?? 0;
    print("LOG == ${[listImage[num]]}, count: $count times");
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
                child: isStart1 ? Container(
                  alignment: Alignment.center,
                  child: DefaultTextStyle(
                    style: TextStyle(fontSize: 0, color: Colors.transparent),
                    child: AnimatedTextKit(
                      isRepeatingAnimation: false,
                      onFinished: () {
                        setState(() {
                          isStart1 = false;
                          startTime();
                        });
                      },
                      animatedTexts: [
                        ScaleAnimatedText('', duration: 0.ms),
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
                      child: Column(
                        children: [
                          SizedBox(height: 15.r),
                          Text("How many times have you seen the below image ??",textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 17.r)),
                          SizedBox(height: 10.r),
                          Padding(
                            padding: const EdgeInsets.only(left: 25, right: 10),
                            child: Container(
                              height: 180.h,
                              width: 180.w,
                              decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/Game/big_rect.png"), fit: BoxFit.fill)),
                              child: Center(
                                child: Image.asset(listImage[num], height: 150.h, width: 150.w),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.r),
                          Container(
                            child: Container(
                              height: 50.h,
                              width: 200.w,
                              decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/Game/btn_bg.png"), fit: BoxFit.fill)),
                              child: Center(
                                child: Text("How Many..?? : $userInput", style: TextStyle(color: Colors.white, fontSize: 20.r)),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(5.r),
                            child: Container(
                              width: 0.25.sh,
                              decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/Game/big_rect.png"), fit: BoxFit.fill)),
                              padding: EdgeInsets.all(5.r),
                              child: GridView.builder(
                                shrinkWrap: true,
                                itemCount: numList.length,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      ClsSound.playSound(SOUNDTYPE.Tap);
                                      // Clear Button
                                      if(index == 9) {
                                        userInput = '';
                                      }
                                      // 0 button
                                      else if(index == 10) {
                                        userInput = '0';
                                      }
                                      // Right Button
                                      else if(index == 11) {
                                        if(clickStatus) {
                                          clickStatus = false;
                                          if(count.toString() == userInput) {
                                            print("ans=$count, select=$userInput");
                                            userInput = '';
                                            initGame();
                                            setState(() {
                                              print("==> correct ${correct++}");
                                              ClsSound.playSound(SOUNDTYPE.Correct);
                                            });
                                          } else {
                                            print("ans=$count, select=$userInput");
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
                                      }
                                      // other buttons
                                      else{
                                        userInput += numList[index];
                                      }
                                      setState(() {});
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(2.r),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(6.4),
                                          color: isOperator(numList[index]) ? Colors.blueAccent : Color(0xff7C89BB),
                                          image: DecorationImage(image: AssetImage("assets/Game/find_btn.png"), fit: BoxFit.fill)
                                      ),
                                      child: Center(
                                        child: Text(numList[index],
                                          style: TextStyle(color: isOperator(numList[index]) ? Colors.white : Colors.white, fontSize: 22.r),
                                        ),
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
            ],
          ),
        ),
      ),
    );
  }

  bool isOperator(String x) {
    if (x == 'x') {
      return true;
    }
    return false;
  }

  CountdownTimer? countDownTimer;

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
    int sum = (session.read(KEY.KEY_TotalCompleteLevel) ?? 0) + 1;
    session.write(KEY.KEY_TotalCompleteLevel, sum);

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
        ResultPage(
          resultInfo: resultInfo,
          gameModel: widget.gameModel,
          nextLevelTap: () {
            print("Next Level Update Come Later");
            Fluttertoast.showToast(
              msg: "Next Level Update Come Later",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey.withOpacity(0.3),
              textColor: Colors.white,
              fontSize: 16.0
            );
          },
        )));
  }
}
