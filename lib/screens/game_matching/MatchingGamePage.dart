import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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

List<String> shapes = ["assets/shapes/1.png", "assets/shapes/2.png", "assets/shapes/3.png", "assets/shapes/4.png", "assets/shapes/5.png", "assets/shapes/6.png", "assets/shapes/7.png", "assets/shapes/8.png","assets/shapes/plus.png", "assets/shapes/minus.png", "assets/shapes/close.png", "assets/shapes/divide.png"];

List<String> startGame(int num, int a) {
  String availableChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  String char = availableChars[Random().nextInt(availableChars.length)];
  if(a == 0){
    availableChars = '123456789';
  }else if(a == 1){
    availableChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  }

  List<String> numList = [];
  for(int i = 0; i < num; i++){
    if(a == 2){
      char = shapes[Random().nextInt(shapes.length)];
      if(numList.isNotEmpty && numList.contains(char)) {
        do {
          char = shapes[Random().nextInt(shapes.length)];
        } while (numList.contains(char));
      }
    }else{
      char = availableChars[Random().nextInt(availableChars.length)];
      if(numList.isNotEmpty && numList.contains(char)) {
        do {
          char = availableChars[Random().nextInt(availableChars.length)];
        } while (numList.contains(char));
      }
    }
    numList.add(char);
  }
  return numList;
}

class MatchingGamePage extends StatefulWidget {
  GameModel gameModel;

  MatchingGamePage({required this.gameModel});

  @override
  State<MatchingGamePage> createState() => _MatchingGamePageState();
}

class _MatchingGamePageState extends State<MatchingGamePage> with TickerProviderStateMixin {
  List cardList = [];
  int? selectedIndex;
  bool isMemorized = true;
  String selected = 'a';
  bool isWrong = true;
  int correct = 0;
  int incorrect = 0;
  int a = 0;
  int _current = 30, count = 0;
  bool isAnimation = false, isStart1 = true, isNew = true;
  late AnimationController _animationController;

  void initGame() {
    a = Random().nextInt(3);
    if(count > 4){
      cardList = startGame(8,a);
    }else{
      cardList = startGame(5,a);
    }

    selected = 'a';
    selectedIndex = 13;
    cardList.add(cardList[Random().nextInt(cardList.length)]);
    cardList.shuffle();
    print(cardList);
    isNew = true;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationController.repeat(reverse: true);
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
                LiveScorePoint(correct,incorrect,_current,widget.gameModel.playTimeSec),
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
                  child: isStart1?Container(
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
                                colors: [red75, red60, red45, red30, red15, Colors.transparent],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.all(30.0),
                            alignment: Alignment.center,
                            child: GridView.builder(
                              itemCount: cardList.length,
                              shrinkWrap: true,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 6.0
                              ),
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index){
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 200),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: Bounce(
                                        duration: const Duration(milliseconds: 150),
                                        onPressed: (){
                                          if(cardList[index] == selected && selectedIndex != index && selectedIndex != 13) {
                                            setState(() {
                                              selectedIndex = index;
                                              print("==> correct ${correct++}");
                                              ClsSound.playSound(SOUNDTYPE.Correct);
                                            });
                                            Future.delayed(100.ms, () {
                                              initGame();
                                              count++;
                                              setState(() {});
                                            });
                                          }else if(!isNew && cardList[index] != selected ){
                                            setState(() {
                                              print("==> incorrect ${incorrect++}");
                                              selectedIndex = 13;
                                              selected = 'a';
                                              isNew = true;
                                              changeWrong();
                                              Vibration.vibrate(duration: 300);
                                            });
                                            Future.delayed(200.ms, () {
                                              changeWrong();
                                              setState(() {});
                                            });
                                          }else {
                                            if (mounted) {
                                              setState(() {
                                                selectedIndex = index;
                                                selected = cardList[index];
                                                isNew = false;
                                              });
                                            }
                                          }
                                        },
                                        child: isWrong ? Card(
                                          color: selectedIndex==index ?primaryColor:bgColor,
                                          child: Center(
                                            child: (a!=2) ? Text(cardList[index], style: TextStyle(color: selectedIndex!=index ?primaryColor:bgColor, fontSize: 40.sp))
                                                : Image.asset(cardList[index], height: 50.h, width: 50.h,color: selectedIndex!=index ?primaryColor:bgColor,),
                                          ),
                                        ).animate(target: selected == cardList[index] ? 1 : 0).shimmer(duration: 200.ms).shake(hz: 2, curve: Curves.easeInOutCubic)
                                            : Card(
                                          color: selectedIndex==index?primaryColor:bgColor,
                                          child: Center(
                                            child: (a!=2) ? Text(cardList[index], style: TextStyle(color: selectedIndex!=index ?primaryColor:bgColor, fontSize: 40.sp))
                                                : Image.asset(cardList[index], height: 50.h, width: 50.h,color: selectedIndex!=index ?primaryColor:bgColor,),
                                          ),
                                        ).animate(target: isWrong ? 1 : 0).shimmer(duration: 200.ms).shake(hz: 8, curve: Curves.easeInOutCubic).scale(begin: Offset(1, 1), end: Offset(0.9, 0.9)),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
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
      route(resultInfo);
    });
  }

  route(ResultInfo resultInfo) {
    List temp = (session.read(KEY.KEY_Unlock) ?? [1]);
    temp.add(gameModelList[18].gameId);
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
              return TipsScreen(gameModel: gameModelList[18]);
            }));
          },
        )));
  }

  changeWrong() {
    isWrong = !isWrong;
  }
}
