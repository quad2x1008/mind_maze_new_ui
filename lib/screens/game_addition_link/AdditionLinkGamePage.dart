import 'dart:async';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

class AdditionLinkGamePage extends StatefulWidget {
  GameModel gameModel;

  AdditionLinkGamePage({required this.gameModel});

  @override
  State<AdditionLinkGamePage> createState() => _AdditionLinkGamePageState();
}

List<int> startGame() {
  List<int> numList = [];
  for (int i = 0; i < 3; i++) {
    numList.add(Random().nextInt(11) + 1);
  }
  return numList;
}

List<int> Options() {
  List<int> optList = [];
  for (int i = 0; i < 25; i++) {
    optList.add(Random().nextInt(3) + 1);
  }
  return optList;
}

class _AdditionLinkGamePageState extends State<AdditionLinkGamePage> with TickerProviderStateMixin {
  bool isAnimation = false, isStart = true;
  List<int> numList = startGame();
  Timer? timer;
  int ans = 0;

  int correct = 0;
  int incorrect = 0;
  int _current = 30;

  bool isDone = true;
  bool isWrong = true;
  List<int> options = Options();
  late AnimationController _animationController;
  final List<int> selectedIndexes = [];
  final key = GlobalKey();
  final _trackTaped = <_Foo>{};

  _detectTapedItem(PointerEvent event) {
    final RenderBox box = key.currentContext!.findAncestorRenderObjectOfType<RenderBox>()!;
    final result = BoxHitTestResult();
    Offset local = box.globalToLocal(event.position);
    if (box.hitTest(result, position: local)) {
      for (final hit in result.path) {
        final target = hit.target;
        if (target is _Foo) {
          _selectIndex(target.index);
        }
      }
    }
  }

  int oldIndex = -1;

  _selectIndex(int index) {
    if (oldIndex == index) return;
    if (selectedIndexes.length == 0 || oldIndex == index - 1 || oldIndex == index + 1 || oldIndex == index + 5 || oldIndex == index - 5) {
      ClsSound.playSound(SOUNDTYPE.Tap);
      oldIndex = index;
      setState(() {
        print('index=${index}==${selectedIndexes}');
        if (selectedIndexes.contains(index)) {
          selectedIndexes.removeRange(selectedIndexes.indexOf(index) + 1, selectedIndexes.length);
          ans = 0;
          selectedIndexes.forEach((element) {
            ans = options[element] + ans;
          });
        } else {
          ans = options[index] + ans;
          selectedIndexes.add(index);
        }
        print('que = ${numList[0]}' + ' num = ${options[index]}' + ' ans = $ans');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
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
                  // Navigator.pop(context);
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
                        children: <Widget>[
                          AnimatedOpacity(
                            opacity: isDone ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 80.w),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
                                  height: 50.w,
                                  width: 50.w,
                                  child: Center(
                                    child: Text(numList[0].toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: 32.0, color: Colors.black)),
                                  ),
                                ).animate(target: isDone ? 1 : 0 ).slide(duration: 200.ms, begin: Offset(1, 0), end: Offset.zero),
                                SizedBox(width: 30.w),
                                Text(numList[1].toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: 35.0, color: white),
                                ).animate(target: isDone ? 1 : 0).slide(delay: 50.ms, duration: 200.ms, begin: Offset(1, 0), end: Offset.zero),
                                SizedBox(width: 30.w),
                                Text(numList[2].toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: 35.0, color: white),
                                ).animate(target: isDone ? 1 : 0).slide(delay: 100.ms, duration: 200.ms, begin: Offset(1, 0), end: Offset.zero),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Container(
                            alignment: Alignment.center,
                            transformAlignment: Alignment.center,
                            margin: EdgeInsets.all(30.0),
                            padding: EdgeInsets.all(12.0),
                            child: Listener(
                              onPointerDown: _detectTapedItem,
                              onPointerMove: _detectTapedItem,
                                onPointerUp: _clearSelection,
                                child: GridView.builder(
                                  key: key,
                                  itemCount: 25,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 5,
                                      crossAxisSpacing: 3.0,
                                      mainAxisSpacing: 3.0,
                                  ),
                                  itemBuilder: (BuildContext context, int index) {
                                    return Foo(
                                      index: index,
                                      child: AnimatedOpacity(
                                        opacity: selectedIndexes.contains(index) ? 0.8 : 1.0,
                                        duration: const Duration(milliseconds: 200),
                                        child: isWrong ? Card(
                                          color: selectedIndexes.contains(index) ? primaryColor : bgColor,
                                          elevation: 6,
                                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                          child: Center(
                                            child: Text(options[index].toString(), textAlign: TextAlign.center,
                                              style: TextStyle(color: selectedIndexes.contains(index) ? white : primaryColor, fontSize: 34.sp),
                                            ),
                                          ),
                                        ).animate(target: (selectedIndexes.contains(index)) ? 1 : 0).shimmer(duration: 200.ms)
                                            .shake(hz: 2, curve: Curves.easeInOutCubic).scale(begin: Offset(1, 1), end: Offset(0.9, 0.9))
                                            : Card(
                                          color: selectedIndexes.contains(index) ? primaryColor : bgColor,
                                          elevation: 6,
                                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                          child: Center(
                                            child: Text(options[index].toString(), textAlign: TextAlign.center,
                                                  style: TextStyle(color: selectedIndexes.contains(index) ? white : primaryColor, fontSize: 34.sp),
                                                ),
                                              ),
                                            ).animate(target: selectedIndexes.contains(index) ? 1 : 0).shimmer(duration: 500.ms,)
                                            .shake(hz: 16, curve: Curves.easeInOutCubic).scale(begin: Offset(1, 1), end: Offset(0.9, 0.9)),
                                          ),
                                        );
                                      },
                                    ),
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
      ),
    );
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

        if(_current == 6) {
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
      goto(resultInfo);
    });
  }

  goto(ResultInfo resultInfo) {
    List<int> myList = [1, 2, 3];
    session.write(KEY.KEY_Unlock, myList);

    List<int>? temp = session.read(KEY.KEY_Unlock) as List<int>?;
    temp!.add(gameModelList[7].gameId);
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
              return TipsScreen(gameModel: gameModelList[7]);
            }));
          },
        )));
  }

  void _clearSelection(PointerUpEvent event) {
    if (ans == numList[0]) {
      for (int i = 0; i < selectedIndexes.length; i++) {
        options[selectedIndexes.elementAt(i)] = Random().nextInt(3) + 1;
      }
      setState(() {
        ans = 0;
        isDone = false;
        numList.removeAt(0);
        numList.add(Random().nextInt(11) + 1);
        correct++;
        ClsSound.playSound(SOUNDTYPE.Correct);
      });
      Future.delayed(Duration(milliseconds: 200), () {
        setState(() {
          isDone = true;
        });
      });
    } else {
      setState(() {
        incorrect++;
        ans = 0;
        isWrong = false;
        Vibration.vibrate(duration: 300);
      });
      Future.delayed(Duration(milliseconds: 200), () {
        setState(() {
          isWrong = true;
        });
      });
    }
    oldIndex = -1;
    setState(() {
      selectedIndexes.clear();
    });
  }
}

class Foo extends SingleChildRenderObjectWidget {
  final int index;

  Foo({required Widget child, required this.index, Key? key}) : super(child: child, key: key);

  @override
  _Foo createRenderObject(BuildContext context) {
    return _Foo(index);
  }

  @override
  void updateRenderObject(BuildContext context, _Foo renderObject) {
    renderObject..index = index;
  }
}

class _Foo extends RenderProxyBox {
  int index;

  _Foo(this.index);
}