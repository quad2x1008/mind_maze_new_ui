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
import '../../QuizBrain.dart';
import '../../common/ClsSound.dart';
import '../../common/Common.dart';
import '../../common/Key.dart';
import '../../constants.dart';
import '../ResultPage.dart';
import '../TimerTitle.dart';
import '../game_operations/LiveScorePoint.dart';

class QuickEyeGamePage extends StatefulWidget {
  GameModel gameModel;

  QuickEyeGamePage({required this.gameModel});

  @override
  State<QuickEyeGamePage> createState() => _QuickEyeGamePageState();
}

const availableChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ123456789';

List<String> startGame(){
  String char = availableChars[Random().nextInt(availableChars.length)];
  List<String> numList = [];
  for(int i = 0; i<3; i++){
    char = availableChars[Random().nextInt(availableChars.length)];
    if(numList.isNotEmpty && numList.contains(char)) {
      do {
        char = availableChars[Random().nextInt(availableChars.length)];
      } while (numList.contains(char));
    }
    numList.add(char);
  }
  return numList;
}

class _QuickEyeGamePageState extends State<QuickEyeGamePage> with TickerProviderStateMixin {
  bool isAnimation = false, isStart = true;
  List<String> numList = [];
  Timer? timer;
  Random random = Random();
  String char = "c";

  int correct = 0;
  int incorrect = 0;
  int _current = 30;

  int selected = 0;
  bool isDone = true, isWrong = true;
  List<int> cardList = [];
  List<String> options = [];
  List<String> optShuffeled = [];
  late List<QuickAnim> AnimList = [];
  late AnimationController _animationController;

  void initGame(){
    numList = startGame();
    numList.forEach((element) {options.add(element);});
    for(int i = 0; i<9; i++){
      if(i<3){
        char = availableChars[random.nextInt(availableChars.length)];
        if(options.contains(char)) {
          do {
            char = availableChars[random.nextInt(availableChars.length)];
          } while (options.contains(char));
        }
        options.add(char);
        optShuffeled.add(char);
      }else{
        options.add("c");
      }
    }
    options.shuffle();
    for (int i = 0; i < options.length; i++){
      AnimList.add(getQuickAnim());
      if(options[i] == "c"){
        cardList.add(i);
        AnimList[i].controller.forward();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initGame();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationController.repeat(reverse: true);
    print(AnimList.length);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        ClsSound.playSound(SOUNDTYPE.Tap);
        countDownTimer?.cancel();
        ClsSound.stopTikTik();
        _animationController.stop();
        return  backButton(context);
      },
      child: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: box_decoration,
          ),
          Scaffold(backgroundColor: Colors.transparent,
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
                    _animationController.dispose();
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
                                colors: [red75, red60, red45, red30, red15,Colors.transparent],
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
                          children: <Widget>[
                            AnimatedOpacity(
                              opacity: isDone ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: 80.w,),
                                  Card(color: white,
                                    child: Card(
                                      color: bgColor,
                                      elevation: 6,
                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                      child: Container(
                                        height: 70.w,
                                        width: 50.w,
                                        child: Center(
                                            child: Text(numList[0], textAlign: TextAlign.center,style: TextStyle(fontSize: 45.sp,color: primaryColor),)
                                        ),
                                      ),
                                    ),
                                  ).animate(target: isDone ? 1 : 0 ).slide(duration: 200.ms, begin: Offset(1, 0), end: Offset.zero),
                                  SizedBox(width: 10.w,),
                                  Card(color: white.withOpacity(0.5),
                                    child: Card(
                                      color: bgColor.withOpacity(0.5),
                                      elevation: 6,
                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                      child: Container(
                                        height: 50.w,
                                        width: 30.w,
                                        child: Center(
                                            child: Text(numList[1], textAlign: TextAlign.center,style: TextStyle(fontSize: 30.sp,color: primaryColor),)
                                        ),
                                      ),
                                    ),
                                  ).animate(target: isDone ? 1 : 0).slide(delay: 50.ms, duration: 200.ms, begin: Offset(1, 0), end: Offset.zero),
                                  SizedBox(width: 10.w,),
                                  Card(
                                    color: white.withOpacity(0.5),
                                    child: Card(
                                      color: bgColor.withOpacity(0.5),
                                      elevation: 6,
                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                      child: Container(
                                        height: 50.w,
                                        width: 30.w,
                                        child: Center(
                                          child: Text(numList[2], textAlign: TextAlign.center,style: TextStyle(fontSize: 30.sp,color: primaryColor),)
                                        ),
                                      ),
                                    ),
                                  ).animate(target: isDone ? 1 : 0).slide(delay: 100.ms, duration: 200.ms, begin: Offset(1, 0), end: Offset.zero),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h,),
                            Container(
                              alignment: Alignment.center,
                              transformAlignment: Alignment.center,
                              height: 300.h,
                              width: 300.h,
                              padding: EdgeInsets.all(12.0),
                              child: GridView.builder(
                                itemCount: 12,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    crossAxisSpacing: 3.0,
                                    mainAxisSpacing: 3.0,
                                    childAspectRatio: 0.5/0.6
                                ),
                                reverse: true,
                                itemBuilder: (BuildContext context, int index){
                                  return InkWell(
                                    onTap: () {
                                      selected = index;
                                      ClsSound.playSound(SOUNDTYPE.Tap);
                                      int num = random.nextInt(optShuffeled.length);
                                      int num1 = cardList[random.nextInt(cardList.length)];
                                      if(options[index] == numList[0]) {
                                        if(mounted){
                                          setState(() {
                                            numList.removeAt(0);
                                            optShuffeled.shuffle();
                                            numList.add(optShuffeled[num]);
                                            optShuffeled.remove(numList[2]);
                                            cardList.remove(num1);
                                            cardList.add(index);
                                            char = availableChars[random.nextInt(availableChars.length)];
                                            if(options.contains(char)){
                                              do {
                                                char = availableChars[random.nextInt(availableChars.length)];
                                              } while(options.contains(char));
                                            }
                                            options[num1] = char;
                                            optShuffeled.add(char);
                                            print(options[num1] +".$num1."+ char);
                                            correct++;
                                            ClsSound.playSound(SOUNDTYPE.Correct);
                                            isDone = false;
                                            Future.delayed(Duration(milliseconds: 200), () {
                                              setState(() {
                                                isDone = true;
                                              });
                                            });
                                            AnimList[index].controller.forward();
                                            AnimList[num1].controller.reverse();
                                          });
                                        }
                                      } else if(options[index] != numList[0] && !cardList.contains(index)){
                                        if(mounted){
                                          print("==> incorrect ${incorrect++}");
                                          Vibration.vibrate(duration: 400);
                                          setState(() {
                                            isWrong = !isWrong;
                                          });
                                          Future.delayed(250.ms,() {
                                            isWrong = !isWrong;
                                            setState(() {});
                                          });
                                        }
                                      }
                                    },
                                    child: Transform(
                                      alignment: FractionalOffset.center,
                                        transform: Matrix4.identity()..setEntry(3, 2, 0.0015)..rotateY(pi * AnimList[index].animation.value),
                                        child: isWrong ? Card(
                                          child: cardList.contains(index) ? Card(
                                            elevation: 6,
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.circular(5),
                                                child: Container(
                                                    child: Image.asset("assets/Game/card.webp",fit: BoxFit.fill),
                                                ),
                                            ),
                                          )
                                              : Card(
                                            color: bgColor,
                                            elevation: 6,
                                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                            child: Center(
                                              child: Text(options[index],textAlign: TextAlign.center,style: TextStyle(color: primaryColor,fontSize: 34),),
                                            ),
                                          ),
                                        )
                                            : Card(
                                            child: cardList.contains(index) ? Card(
                                              elevation: 6,
                                              child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(5),
                                                  child: Container(
                                                      child: Image.asset("assets/Game/card.webp", fit: BoxFit.fill),
                                                  ),
                                              ),
                                            )
                                                : Card(
                                              color: bgColor,
                                              elevation: 6,
                                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                              child: Center(
                                                child: Text(options[index],textAlign: TextAlign.center,style: TextStyle(color: primaryColor,fontSize: 34),),
                                              ),
                                            ),
                                        ).animate(target: selected == index ? 1 : 0).shake(hz: 8, curve: Curves.easeInOutCubic,duration: 200.ms)
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 20.h),
                          ],
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
    );
  }

  QuickAnim getQuickAnim(){
    AnimationController _controller;
    Animation _animation;
    AnimationStatus _status = AnimationStatus.dismissed;

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _animation = Tween(end: 1.0, begin: 0.0).animate(_controller)
      ..addListener(() {})
      ..addStatusListener((status) {
        _status = status;
      });

    return QuickAnim(controller: _controller, animation: _animation, status: _status);
  }

  @override
  void dispose() {
    countDownTimer?.cancel();
    ClsSound.stopTikTik();
    _animationController.stop();
    _animationController.dispose();
    AnimList.forEach((anim) => anim.controller.dispose());
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

        if(_current==6){
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
    temp.add(gameModelList[10].gameId);
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
              return TipsScreen(gameModel: gameModelList[10]);
            }));
          },
        )));
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
