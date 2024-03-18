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
import '../../common/ClsSound.dart';
import '../../common/Common.dart';
import '../../common/Key.dart';
import '../../constants.dart';
import '../ResultPage.dart';
import '../TimerTitle.dart';
import '../game_operations/LiveScorePoint.dart';

class TapColorGamePage extends StatefulWidget {
  GameModel gameModel;

  TapColorGamePage({required this.gameModel});

  @override
  State<TapColorGamePage> createState() => _TapColorGamePageState();
}

class _TapColorGamePageState extends State<TapColorGamePage> with TickerProviderStateMixin {
  bool _canShowButton = true;
  int? selectedIndex;
  bool isAnimation = true, isStart = true, isWrong = true;
  bool isAnimation1 = false;

  route(ResultInfo resultInfo) {
    List temp = (session.read(KEY.KEY_Unlock) ?? [1]);
    temp.add(gameModelList[13].gameId);
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
              return TipsScreen(gameModel: gameModelList[13]);
            }));
          },
        )));
  }

  List<Color> colorsList = [
    Colors.yellow,
    Colors.green,
    Colors.pink,
    Colors.redAccent,
    Colors.blue,
    Colors.orange
  ];

  List quesColor = [];
  List memorized = [];
  List answeredCard = [];
  List<bool> showCard = [];
  int ansDone=0;
  Random random = Random();

  int correct = 0;
  int incorrect = 0;
  int _current = 30;

  bool isDone = true;
  late AnimationController _animationController;

  void startGame() {
    ansDone=0;
    _canShowButton=true;
    memorized=[];
    quesColor=[];
    answeredCard=[];
    Color color = colorsList[0];
    for(var i = 0; i < 3; i++) {
      color = colorsList[random.nextInt(colorsList.length)];
      memorized.add(color);
      quesColor.add(color);
    }
    quesColor.shuffle();
    showCard = List.filled(quesColor.length, true);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    startGame();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animationController.repeat(reverse: true);
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
                  child: isStart? Container(
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
                        visible: isAnimation1,
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
                      Center(
                        child: SizedBox(
                          height: 380,
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Visibility(
                                visible: !_canShowButton,
                                child: Container(
                                  height: 50,
                                  width: 100,
                                  padding: const EdgeInsets.all(12.0),
                                  child: GridView.builder(
                                    itemCount: 3,
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 3.0,
                                        mainAxisSpacing: 3.0
                                      ),
                                      itemBuilder: (BuildContext context, int index){
                                        return AnimationConfiguration.staggeredList(
                                          position: index,
                                          duration: const Duration(milliseconds: 300),
                                          child: SlideAnimation(
                                            verticalOffset: 50.0,
                                            child: FadeInAnimation(
                                              child: Card(color:  quesColor[index]),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: !_canShowButton,
                                  child: Container(
                                    height: 300,
                                    width: 300,
                                    padding: const EdgeInsets.all(12.0),
                                    child: GridView.builder(
                                      itemCount: 3,
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 3.0,
                                          mainAxisSpacing: 3.0
                                      ),
                                      itemBuilder: (BuildContext context, int index){
                                        return AnimationConfiguration.staggeredList(
                                          position: index,
                                          duration: const Duration(milliseconds: 500),
                                          child: SlideAnimation(
                                            verticalOffset: 50.0,
                                            child: FadeInAnimation(
                                              child: Bounce(
                                                duration: const Duration(milliseconds: 200),
                                                onPressed: (){
                                                  if(answeredCard.contains(index)){
                                                    return;
                                                  }
                                                  showCard[index] = true;
                                                  if(memorized[index] == quesColor[ansDone]) {
                                                    answeredCard.add(index);
                                                    ansDone++;
                                                    if(ansDone==quesColor.length){
                                                      correct++;
                                                      startGame();
                                                    }
                                                  } else {
                                                    incorrect++;
                                                    print("==> incorrect ${incorrect}");
                                                    setState(() {
                                                      isAnimation = false;
                                                      changeWrong();
                                                    });
                                                    Future.delayed(150.ms,(){
                                                      if(mounted){
                                                        setState(() {
                                                          changeWrong();
                                                          isAnimation = true;
                                                        });
                                                      }
                                                      startGame();
                                                    });
                                                  }
                                                  selectedIndex = index;
                                                  setState(() {});
                                                },
                                                child: Card(
                                                  color: showCard[index] ? memorized[index] : Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ).animate(target: isAnimation ? 1 : 0).shimmer(duration: 200.ms).shake(hz: 2, curve: Curves.easeInOutCubic),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 300,
                                    width: 300,
                                    padding: const EdgeInsets.all(12.0),
                                    child: GridView.builder(
                                      itemCount: 3,
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 3.0,
                                          mainAxisSpacing: 3.0
                                      ),
                                      itemBuilder: (BuildContext context, int index){
                                        return AnimationConfiguration.staggeredList(
                                          position: index,
                                          duration: const Duration(milliseconds: 500),
                                          child: SlideAnimation(
                                            verticalOffset: 50.0,
                                            child: FadeInAnimation(
                                              child: Bounce(
                                                duration: const Duration(milliseconds: 200),
                                                onPressed: (){
                                                  isAnimation = true;
                                                },
                                                child: Card(
                                                  color: showCard[index] ? memorized[index] : Colors.grey,
                                                ).animate(target: isAnimation ? 1 : 0).shake(hz: 8, curve: Curves.easeInOutCubic).scale(begin: const Offset(1,1),end: const Offset(0.8,0.8)),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ).animate(target: isAnimation ? 1 : 0).shimmer(duration: 200.ms).shake(hz: 2, curve: Curves.easeInOutCubic),
                                ),
                                const SizedBox(height: 10),
                                Visibility(
                                  visible: _canShowButton,
                                  child: GestureDetector(
                                    onTap: () {
                                      showCard = List.filled(showCard.length, false);
                                      _canShowButton = false;
                                      setState(() {});
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 80.0),
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
                        ),
                      ],
                    )
                ),
              ],
            ),
          ),
        ],
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
      const Duration(seconds: 1),
    );

    var sub = countDownTimer!.listen(null);
    sub.onData((duration) {
      setState(() {
        _current = widget.gameModel.playTimeSec - duration.elapsed.inSeconds;

        if (_current == 6) {
          ClsSound.playTikTik();
        }
        if (_current < 6) {
          isAnimation1 = true;
        }
      });
    });

    sub.onDone(() {
      ResultInfo resultInfo = ResultInfo(no_of_que: correct + incorrect, correct: correct, incorrect: incorrect);
      sub.cancel();
      route(resultInfo);
    });
  }

  changeWrong() {
    isWrong = !isWrong;
  }
}
