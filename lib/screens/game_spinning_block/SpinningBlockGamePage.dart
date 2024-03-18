import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
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

class SpiningBlockGamePage extends StatefulWidget {
  GameModel gameModel;

  SpiningBlockGamePage({required this.gameModel});

  @override
  State<SpiningBlockGamePage> createState() => _SpiningBlockGamePageState();
}

List<int> startGame() {
  List<int> numList = [];
  for (int i = 0; i < 3; i++) {
    int num = Random().nextInt(9);
    if(numList.isNotEmpty && numList.contains(num)){
      do{
        num = Random().nextInt(9);
      }while(numList.contains(num));
    }
    numList.add(num);
  }
  print(numList);
  return numList;
}

class _SpiningBlockGamePageState extends State<SpiningBlockGamePage> with TickerProviderStateMixin {
  bool isAnimation = false, isStart = true, isWrong = false;
  List<int> numList = [];
  int count = 0,len = 0;

  int correct = 0;
  int incorrect = 0;
  int _current = 30;
  int progress = 20,animTime = 1000;
  int random = Random().nextInt(2);
  bool isMemorized = false;
  late AnimationController _controllerH,_controllerV;
  late Animation _animationH,_animationV;
  AnimationStatus _statusH = AnimationStatus.dismissed, _statusV = AnimationStatus.dismissed;
  int selected = 0;
  List<Color> optSelected = [bgColor, bgColor, bgColor,bgColor, bgColor, bgColor,bgColor, bgColor, bgColor,];
  late AnimationController _animationController;
  double turns = 0.0;
  int nextIntRange(int min, int max) => min + Random().nextInt((max + 1) - min);
  void _changeRotation() {
    int num = nextIntRange(-2, 2);
    if(num == 0){
      do{
        num = nextIntRange(-2, 2);
      }while(num==0);
    }
    print(num);
    setState(() => turns += ((1.0 / 4.0)*num));
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationController.repeat(reverse: true);
    _controllerH = AnimationController(vsync: this, duration: Duration(milliseconds: animTime));
    _animationH = Tween(end: 1.0, begin: 0.0).animate(_controllerH)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        _statusH = status;
      });
    _controllerV = AnimationController(vsync: this, duration: Duration(milliseconds: animTime));
    _animationV = Tween(end: 1.0, begin: 0.0).animate(_controllerV)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        _statusV = status;
      });
    initGame();
  }

  void initGame(){
    setState(() {
      len = 0;
      isMemorized = false;
      numList = startGame();
      for(int i = 0; i<optSelected.length; i++){
        if(numList.contains(i)){
          optSelected[i] = primaryColor;
        }else{
          optSelected[i] = bgColor;
        }
      }
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
                ): Stack(
                  children: [
                    Visibility(
                      visible: isWrong,
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
                      transformAlignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            transformAlignment: Alignment.center,
                            height: 300.h,
                            width: 300.h,
                            margin: EdgeInsets.all(30.0),
                            padding: EdgeInsets.all(12.0),
                            child: random == 0 ? Transform(
                              alignment: FractionalOffset.center,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.0015)
                                ..rotateY(pi * _animationH.value),
                              child: AnimatedRotation(
                                  turns: turns,
                                  alignment: Alignment.center,
                                  duration: const Duration(seconds: 1),
                                  child: GridView.builder(
                                    itemCount: 9,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 3.0, mainAxisSpacing: 3.0),
                                    itemBuilder: (BuildContext context, int index) {
                                      return Bounce(
                                        duration: Duration(milliseconds: 200),
                                        onPressed: () {
                                          ClsSound.playSound(SOUNDTYPE.Tap);
                                          selected = index;
                                          if(isMemorized){
                                            Future.delayed(Duration(milliseconds: 0),(){
                                              if(numList.contains(index)){
                                                setState(() {
                                                  if(optSelected[index] != primaryColor){
                                                    len++;
                                                    print("==> correct ${correct++}");
                                                    ClsSound.playSound(SOUNDTYPE.Correct);
                                                  }
                                                  optSelected[index] = primaryColor;
                                                  if(len==numList.length){
                                                    Future.delayed(Duration(milliseconds: 500), () {
                                                      setState(() {
                                                        initGame();
                                                      });
                                                    });
                                                  }
                                                });
                                              }else{
                                                print("==> incorrect ${incorrect++}");
                                                Vibration.vibrate(duration: 400);
                                                changeWrong();
                                                Future.delayed(Duration(milliseconds: 500), () {
                                                  setState(() {
                                                    changeWrong();
                                                    initGame();
                                                  });
                                                });
                                              }
                                            });
                                          }
                                          },
                                        child: Card(
                                          color: optSelected[index],
                                          elevation: 6,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                          ),
                                        ).animate(target: selected != index ? 1 : 0).shimmer(duration: 200.ms),
                                      );
                                      },
                                  ),
                              ),
                            ) : Transform(
                              alignment: FractionalOffset.center,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.002)
                                ..rotateX(pi * _animationV.value),
                              child: AnimatedRotation(
                                  turns: turns,
                                  alignment: Alignment.center,
                                  duration: const Duration(seconds: 1),
                                  child: GridView.builder(
                                    itemCount: 9,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 3.0, mainAxisSpacing: 3.0),
                                    itemBuilder: (BuildContext context, int index) {
                                      return Bounce(
                                        duration: Duration(milliseconds: 200),
                                        onPressed: () {
                                          ClsSound.playSound(SOUNDTYPE.Tap);
                                          selected = index;
                                          if(isMemorized){
                                            Future.delayed(Duration(milliseconds: 0),(){
                                              if(numList.contains(index)){
                                                setState(() {
                                                  if(optSelected[index] != primaryColor){
                                                    len++;
                                                    print("==> correct ${correct++}");
                                                    ClsSound.playSound(SOUNDTYPE.Correct);
                                                  }
                                                  optSelected[index] = primaryColor;
                                                  if(len==numList.length){
                                                    Future.delayed(Duration(milliseconds: 500), () {
                                                      setState(() {
                                                        initGame();
                                                      });
                                                    });
                                                  }
                                                });
                                              }else{
                                                print("==> incorrect ${incorrect++}");
                                                Vibration.vibrate(duration: 400);
                                                changeWrong();
                                                Future.delayed(Duration(milliseconds: 500), () {
                                                  setState(() {
                                                    changeWrong();
                                                    initGame();
                                                  });
                                                    });
                                              }
                                            });
                                          }
                                          },
                                        child: Card(
                                          color: optSelected[index],
                                          elevation: 6,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                          ),
                                        ).animate(target: selected != index ? 1 : 0).shimmer(duration: 200.ms),
                                      );
                                      },
                                  ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Visibility(
                            visible: !isMemorized,
                            child: InkWell(
                              onTap: (){
                                count++;
                                setState(() {
                                  for(int i = 0; i<optSelected.length; i++){  optSelected[i] = bgColor;};
                                });
                                print(optSelected[0]);
                                random = Random().nextInt(2);
                                if(random==0){
                                  bool i = Random().nextBool();
                                  if(i){
                                    if(_statusH == AnimationStatus.dismissed){
                                      _controllerH.forward();
                                    }else{
                                      _controllerH.reverse();
                                    }
                                  }else {
                                    _changeRotation();
                                  }
                                }else if(count > 8) {
                                  if(random==0){
                                    if(_statusH == AnimationStatus.dismissed){
                                      _controllerH.forward();
                                    }else{
                                      _controllerH.reverse();
                                    }
                                    Future.delayed(Duration(milliseconds: 1200), () {
                                      setState(() {
                                        _changeRotation();
                                      });
                                    });
                                  }else {
                                    if(_statusV == AnimationStatus.dismissed){
                                      _controllerV.forward();
                                    }else{
                                      _controllerV.reverse();
                                    }
                                    Future.delayed(Duration(milliseconds: 1200), () {
                                      setState(() {
                                        _changeRotation();
                                      });
                                    });
                                  }
                                } else {
                                  bool i = Random().nextBool();
                                  if(i){
                                    if(_statusV == AnimationStatus.dismissed){
                                      _controllerV.forward();
                                    }else{
                                      _controllerV.reverse();
                                    }
                                  }else {
                                    _changeRotation();
                                  }
                                }
                                setState(() {
                                  isMemorized = !isMemorized;
                                });
                                },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 80.0),
                                child: SizedBox(
                                  height: 60.h,
                                  width: 180.w,
                                  child: Card(
                                      elevation: 5,
                                      color: Colors.orange,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.r))),
                                      child: Center(child: Text("Memorized", textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 20.sp),),)
                                  ),
                                ),
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
    temp.add(gameModelList[12].gameId);
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
              return TipsScreen(gameModel: gameModelList[12]);
            }));
          },
        )));
  }

  changeWrong() {
    isWrong = !isWrong;
  }
}
