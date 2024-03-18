import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mind_maze/common/Common.dart';
import 'package:mind_maze/screens/Play%20with%20frd/SizeConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/ClsSound.dart';
import '../../constants.dart';

class ScoreBoardFrd extends StatefulWidget {
  ScoreBoardFrd({Key? key}) : super(key: key);

  @override
  State<ScoreBoardFrd> createState() => _ScoreBoardFrdState();
}

class _ScoreBoardFrdState extends State<ScoreBoardFrd> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Board> data = [];
  bool isnodata = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.containsKey("ScoreBoardJson")) {
        String? str = prefs.getString("ScoreBoardJson");
        if(str != "") {
          var convertedjson = json.decode(str!);
          ScoreBoardJson sjson = ScoreBoardJson.fromJson(convertedjson);
          data = sjson.board.toList().reversed.toList();
        } else {
          isnodata = true;
        }
      } else {
        isnodata = true;
      }
    } on Exception catch (e) {
      print(e.toString());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return backButton(context);
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: box_decoration,
          child: Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 30.r, left: 20.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          ClsSound.playSound(SOUNDTYPE.Tap);
                          Navigator.pop(context);
                        },
                        child: Image.asset("assets/Game/back.png", height: 30.r, width: 40.r, fit: BoxFit.fill),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(30.r, 5.r, 30.r, 5.r),
                        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/Game/btn_bg.png"), fit: BoxFit.fill)),
                        child: Text("Score Board", style: TextStyle(color: txtColor, fontWeight: FontWeight.bold, fontSize: 25.r)),
                      ),
                      SizedBox(width: 60.r),
                    ],
                  ),
                ),
                Expanded(
                  child: isnodata ? Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 10.w, top: 80.h, bottom: 50.h, right: 0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("No Data Found".toUpperCase(),
                          style: TextStyle(fontSize: 20.sp, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ) : data.length > 0 ? Container(
                    margin: EdgeInsets.only(left: 0, top: 5.h, bottom: 5.h, right: 0),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(left: 5.w, top: 0, bottom: 5.h, right: 5.w),
                          decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/que_board.png"), fit: BoxFit.fill)),
                          child: Container(
                            margin: EdgeInsets.only(left: 0, top: 5.h, bottom: 15.h, right: 0),
                            child: Column(
                              children: [
                                //
                                Padding(
                                  padding: EdgeInsets.only(top: 10.h, bottom: 0, right: 0, left: 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text((data[index].mode == "0" ? "Easy" : data[index].mode == "1" ? "Medium"
                                          : data[index].mode == "2" ? "Hard" : "Complex") + " - " + data[index].noofquestion! + " Question",
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 14.sp)),
                                      Text(data[index].datetime!, style: TextStyle(color: Colors.white.withOpacity(0.7),
                                          fontWeight: FontWeight.w400, fontSize: 12.sp)),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1.h,
                                  width: SizeConfig.screenWidth - 50.w,
                                  color: Colors.white,
                                  margin: EdgeInsets.only(left: 0, top: 5.h, bottom: 5.h, right: 0),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: (SizeConfig.screenWidth - 22.w) / 2,
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(left: 10.w, top: 0, bottom: 0, right: 0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(left: 0, right: 10.w, bottom: 0, top: 0),
                                                child: Container(
                                                  height: 25.h,
                                                  width: 25.w,
                                                  child: Image.asset(data[index].player1emoji!, height: 20.h, width: 20.w, fit: BoxFit.contain),
                                                ),
                                              ),
                                              Text(data[index].player1name!, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14.sp)),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 10.h),
                                            child: Text("Score: " + data[index].player1score!,
                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14.sp)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 10.h),
                                            child: Text(int.parse(data[index].player1score!) > int.parse(data[index].player2score!)
                                                ? "Winner".toUpperCase() : int.parse(data[index].player1score!) == int.parse(data[index].player2score!)
                                                ? "It's Tie".toUpperCase() : "Losser".toUpperCase(),
                                              style: TextStyle(color: int.parse(data[index].player1score!) > int.parse(data[index].player2score!)
                                                  ? Colors.green : int.parse(data[index].player1score!) == int.parse(data[index].player2score!)
                                                  ? Color(0xFF5B5B5B) : Colors.red, fontWeight: FontWeight.w900, fontSize: 16.sp)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      width: 1,
                                      color: Colors.white,
                                      height: 80.h,
                                    ),
                                    Container(
                                      width: (SizeConfig.screenWidth - 22.w) / 2,
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(left: 0, right: 10.w, bottom: 0, top: 0),
                                                child: Container(
                                                  height: 25.h,
                                                  width: 25.w,
                                                  child: Image.asset(data[index].player2emoji!, height: 25.h, width: 25.w, fit: BoxFit.contain),
                                                ),
                                              ),
                                              Text(data[index].player2name!, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14.sp))
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 10.h),
                                            child: Text("Score: " + data[index].player2score!,
                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14.sp)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 10.h),
                                            child: Text(int.parse(data[index].player2score!) > int.parse(data[index].player1score!)
                                                ? "Winner".toUpperCase() : int.parse(data[index].player1score!) == int.parse(data[index].player2score!)
                                                ? "It's Tie".toUpperCase() : "Losser".toUpperCase(),
                                              style: TextStyle(color: int.parse(data[index].player2score!) > int.parse(data[index].player1score!)
                                                ? Colors.green : int.parse(data[index].player1score!) == int.parse(data[index].player2score!)
                                                ? Color(0xFF5B5B5B) : Colors.red, fontWeight: FontWeight.w900, fontSize: 14.sp)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                //
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ) : const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
