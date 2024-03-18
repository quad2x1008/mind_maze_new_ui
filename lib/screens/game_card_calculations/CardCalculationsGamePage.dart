import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
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

class CardCalCulationGamePage extends StatefulWidget {
  GameModel gameModel;

  CardCalCulationGamePage({required this.gameModel});

  @override
  State<CardCalCulationGamePage> createState() => _CardCalCulationGamePageState();
}

class _CardCalCulationGamePageState extends State<CardCalCulationGamePage> with TickerProviderStateMixin {
  bool isAnimation = false, isStart = true;
  int count = 0,len = 0;
  bool isWrong = true;
  int correct = 0;
  int incorrect = 0;
  int _current = 30;
  int num1 = 0, num2 = 0;
  int progress = 20,animTime = 1000;
  Random random = Random();
  bool isDone = true, isMemorized = false;
  late AnimationController _controller;
  late Animation _animation;
  AnimationStatus _status = AnimationStatus.dismissed;
  int selected = 0;
  late AnimationController _animationController;
  double turns = 0.0;

  List<Color> colors = [
    primaryColor,
    Colors.pink,
  ];

  int gridSize1 = 2;
  int gridSize2 = 2;
  bool _isvisible = false;

  bool is_visible_margin_1 = true;
  bool is_visible_margin_2 = true;
  EdgeInsets margin_2x2 = EdgeInsets.fromLTRB(85, 0, 85, 0);
  EdgeInsets margin_3x3 = EdgeInsets.fromLTRB(35, 0, 35, 0);

  bool isBack = true;
  double angle = 0;

  void _flip() {
    setState(() {
      angle = (angle + pi) % (50 * pi);
    });
  }

  late Animation<double> animation;
  late AnimationController animController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationController.repeat(reverse: true);
    startGame();
    _flip();

    animController = AnimationController(
      reverseDuration: Duration(milliseconds: 300),
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    animation = Tween<double>(begin: 1, end: 1.2).animate(animController)..addListener(() {
        setState(() {});
      })..addStatusListener((status) {});
    animController.forward();
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
                                      )
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
                    Visibility(
                      visible: !_isvisible,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ListView(
                            shrinkWrap: true,
                            children: [
                              Container(
                                margin: is_visible_margin_1 ? margin_2x2 : margin_3x3,
                                child: StaggeredGrid.count(
                                  crossAxisCount: gridSize1,
                                  mainAxisSpacing: 7,
                                  crossAxisSpacing: 20,
                                  children: numList.map<Widget>((item) {
                                    return TweenAnimationBuilder(
                                        tween: Tween<double>(begin: 0, end: angle),
                                        duration: Duration(seconds: 1),
                                        builder: (BuildContext context, double val, __) {
                                          if (val >= (pi / 2)) {
                                            isBack = false;
                                          } else {
                                            isBack = true;
                                          }
                                          return Transform(
                                            alignment: FractionalOffset.center,
                                            transform: Matrix4.identity()..setEntry(3, 2, 0.0015)..rotateY(val),
                                            child: isBack ? Card(
                                              elevation: 12,
                                              child: Container(
                                                height: 105,
                                                width: 90,
                                                decoration: BoxDecoration(
                                                  color: item > 0 ? colors[0] : colors[1],
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(width: 2, color: Colors.white),
                                                ),
                                              ),
                                            ) : Transform(
                                              alignment: Alignment.center,
                                              transform: Matrix4.identity()..rotateY(pi),
                                              child: Card(
                                                elevation: 12,
                                                child: Container(
                                                  height: 105,
                                                  width: 90,
                                                  decoration: BoxDecoration(
                                                    color: item > 0 ? colors[0] : colors[1],
                                                    borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(width: 2, color: Colors.white),
                                                  ),
                                                  child: Center(
                                                    child: Text('${item.abs()}', style: TextStyle(fontSize: 32, color: Colors.white)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 100),
                              Transform.scale(
                                scale: animation.value,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _isvisible = !_isvisible;
                                    });
                                  },
                                  child: Text('Memorized!'),
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(230, 50),
                                    textStyle: TextStyle(color: Colors.black, fontSize: 25,fontFamily: 'Berry'),
                                    backgroundColor: Colors.orange,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: _isvisible,
                          child: Center(
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                Container(
                                  margin: is_visible_margin_2 ? margin_2x2 : margin_3x3,
                                  child: StaggeredGrid.count(
                                    crossAxisCount: gridSize2,
                                    mainAxisSpacing: 7,
                                    crossAxisSpacing: 7,
                                    children: options.map<Widget>((item) {
                                      return optionBox(item);
                                    }).toList(),
                                  ),
                                ),
                              ],
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

  List<int> numList = [];
  int num = 2;
  int ans = 0;
  int counter = 0;
  int final_ans = 0;

  void startGame() {
    numList = [];
    ans = 0;
    options = [];

    for (int i = 0; i < num; i++) {
      int randNum = (random.nextInt(9) + 1);
      numList.add(randNum);
      print('${numList[i]}');
    }

    numList.sort((a, b) => a.compareTo(b));
    print(numList);
    for (int i = 0; i < numList.length - 1; i++) {
      numList[i] = numList[i] * (random.nextBool() ? -1 : 1);
    }

    for (int i = 0; i < numList.length; i++) {
      ans += numList[i];
    }
    final_ans = ans.abs();
    print('ans == $final_ans');

    getOption();

    setState(() {});
  }

  optionBox(int item) {
    return Bounce(
      duration: Duration(milliseconds: 150),
      onPressed: () {
        counter++;
        if (final_ans == item) {
          correct++;
          setState(() {
            startGame();
            _isvisible = false;
          });
          print('correct == ${correct}');
        } else {
          incorrect++;
          print('incorrect == ${incorrect}');
          setState(() {
            startGame();
            _isvisible = false;
            isWrong = !isWrong;
            Vibration.vibrate(duration: 300);
          });
          Future.delayed(200.ms, () {
            isWrong = !isWrong;
            setState(() {});
          });
        }
        if (counter == 2) {
          print('counter == ${counter}');
          num = 3;
          opt = 5;
        }
        if (counter == 3) {
          gridSize1 = 3;
          gridSize2 = 3;
          is_visible_margin_1 = false;
          is_visible_margin_2 = false;
        }
        if (counter == 5) {
          opt = 8;
        }
        if (counter == 8) {
          num = 4;
          opt = 5;
        }
        if (counter == 9) {
          gridSize1 = 2;
          is_visible_margin_1 = true;
        }
        if (counter == 11) {
          opt = 8;
        }
      },
      child: Container(
        child: SizedBox(
          height: 110,
          width: 85,
          child: Card(
            color: Colors.white,
            elevation: 6,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Center(
              child: Text('$item', style: TextStyle(color: primaryColor, fontSize: 30)),
            ),
          ),
        ),
      ),
    );
  }

  int nextIntRange(int min, int max) => min + Random().nextInt((max + 1) - min);

  List<int> options = [];
  int opt = 3;

  getOption() {
    options.add(final_ans);
    for (int i = 0; i < opt; i++) {
      int op = 0;
      do {
        op = nextIntRange(final_ans - 5, final_ans + 5);
      } while (options.contains(op));
      options.add(op);
    }

    options.shuffle();
    print('options == $final_ans $options');
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
      goto(resultInfo);
    });
  }

  goto(ResultInfo resultInfo) async {
    List temp = (session.read(KEY.KEY_Unlock) ?? [1]);
    temp.add(gameModelList[14].gameId);
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
              return TipsScreen(gameModel: gameModelList[14]);
            }));
          },
        )));
  }
}
