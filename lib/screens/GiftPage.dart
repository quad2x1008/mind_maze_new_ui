import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:confetti/confetti.dart';
import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:mind_maze/common/Common.dart';
import 'package:mind_maze/screens/GameModel.dart';
import '../common/ClsSound.dart';

class GiftPage extends StatefulWidget {
  int points = 0;
  late GameModel gameModel;

  GiftPage({required this.points, required this.gameModel});

  @override
  State<GiftPage> createState() => _GiftPageState();
}

class _GiftPageState extends State<GiftPage> with TickerProviderStateMixin {
  late ConfettiController _controllerTopCenter;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controllerTopCenter = ConfettiController(duration: Duration(seconds: 10));
    _controllerTopCenter.play();
  }

  static const colorizeColors = [
    Colors.white,
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _controllerTopCenter.stop();
        Navigator.pop(context);
        return Future.value(false);
      },
      child: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: box_decoration,
          ),
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: _controllerTopCenter,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: true,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
                Colors.yellow
              ],
            ),
          ),
          Scaffold(
            backgroundColor: Colors.black12,
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: Container(
                child: InkWell(
                  onTap: () {
                    ClsSound.playSound(SOUNDTYPE.Tap);
                    _controllerTopCenter.stop();
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.close, size: 30.r, color: Colors.blue),
                ),
              ),
            ),
            body: Container(
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedTextKit(
                          animatedTexts: [
                            ColorizeAnimatedText("Amazing",
                                textStyle: TextStyle(fontSize: 44.sp, color: Colors.white), colors: colorizeColors)
                          ],
                          repeatForever: true,
                        ),
                        Padding(padding: EdgeInsets.all(20)),
                        Container(
                          child: Lottie.asset('assets/lotti/giftbox.json', controller: _controller,
                            onLoaded: (composition) {
                              _controller..duration = composition.duration..forward();
                              Future.delayed(Duration(milliseconds: 3000), () {
                                setState(() {
                                  _controller.stop();
                                });
                              });
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 50.w,
                              child: Lottie.asset('assets/lotti/67203-3d-coin.json'),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Container(
                                child: Countup(
                                  begin: 0,
                                  end: widget.points.toDouble(),
                                  duration: Duration(seconds: 3),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontSize: 20.sp),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.all(10)),
                        AnimatedTextKit(
                          animatedTexts: [
                            TyperAnimatedText("You won 2x Points.", speed: 300.ms,
                                textStyle: TextStyle(fontSize: 24.sp, color: Colors.white)),
                          ],
                          isRepeatingAnimation: false,
                        ),
                        Padding(padding: EdgeInsets.all(10)),
                        GestureDetector(
                          onTap: () {
                            ClsSound.playSound(SOUNDTYPE.Tap);
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 40.w,
                            width: 120.w,
                            alignment: Alignment.center,
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.orangeAccent.withOpacity(0.8),
                              border: Border.all(width: 2, color: Colors.white.withOpacity(0.8)),
                            ),
                            child: Text('Skip', textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
    _controllerTopCenter.stop();
    _controllerTopCenter.dispose();
    _controller.dispose();
    super.dispose();
  }
}
