import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mind_maze/common/ClsSound.dart';

class EmojiDialog extends StatefulWidget {
  final String? selectedemoji;
  final void Function(String?)? onEmojiSelected;

  EmojiDialog({this.onEmojiSelected, this.selectedemoji});

  @override
  State<EmojiDialog> createState() => _EmojiDialogState();
}

class _EmojiDialogState extends State<EmojiDialog> {
  String? emoji;
  List<String> emojiList = ["assets/e1.png", "assets/e2.png", "assets/e3.png", "assets/e4.png", "assets/e5.png", "assets/e6.png", "assets/e7.png", "assets/e8.png", "assets/e9.png", "assets/e10.png", "assets/e11.png", "assets/e12.png", "assets/e13.png", "assets/e14.png", "assets/e15.png"];

  @override
  void initState() {
    super.initState();
    emoji = widget.selectedemoji;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 0.75.sh,
      width: 0.80.sw,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: Colors.transparent,
            alignment: Alignment.center,
            child: Image.asset("assets/bg_emoji.png", height: 0.65.sh, width: 0.80.sw, fit: BoxFit.fill),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 10.h, left: 5.w),
            height: 0.67.sh,
            width: 0.75.sw,
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: emojiList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Center(
                  child: Bounce(
                    duration: Duration(milliseconds: 200),
                    onPressed: () {
                      ClsSound.playSound(SOUNDTYPE.Tap);
                      setState(() {
                        emoji = emojiList[index];
                      });
                    },
                    child: Container(
                      height: 70.w,
                      width: 70.w,
                      decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.fill, image: AssetImage("assets/ans_box.png"), colorFilter: emoji == emojiList[index] ? ColorFilter.mode(Colors.white.withOpacity(1), BlendMode.modulate) : ColorFilter.mode(Colors.white.withOpacity(0.5), BlendMode.modulate))),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 20.0, right: 20.0, left: 10.0, top: 10.0),
                        child: Image.asset(emojiList[index], height: 35.w, width: 35.w, fit: BoxFit.contain),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 0.65.sh),
            child: Bounce(
              duration: Duration(milliseconds: 200),
              onPressed: () {
                ClsSound.playSound(SOUNDTYPE.Tap);
                widget.onEmojiSelected!(emoji);
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
              child: Container(
                alignment: Alignment.center,
                height: 40.h,
                width: 0.35.sw,
                decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/bg_set.png"), fit: BoxFit.fill)),
                child: Text("Set".toUpperCase(), style: TextStyle(fontSize: 20.sp, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
