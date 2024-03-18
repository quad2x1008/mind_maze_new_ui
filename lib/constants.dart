import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

int count = 1;
bool? rateComplete = false;
List<String> scoreImageList = [];

class Constants {
  Constants._();

  static const double padding = 20;
  static const double avatarRadius = 45;
}

class ResultInfo {
  int? no_of_que, correct, incorrect;

  ResultInfo({this.no_of_que, this.correct, this.incorrect});
}

class ResultInfoFrd {
  int? no_of_que, correct1, incorrect1, correct2, incorrect2;

  ResultInfoFrd({this.no_of_que, this.correct1, this.incorrect1, this.correct2, this.incorrect2});
}

class ShareData {
  double? percent, time;
  int? correct, incorrect;

  ShareData({this.percent, this.time, this.correct, this.incorrect});
}

class ShareDataFrd {
  double? percent1, percent2, time;
  int? correct1, correct2, incorrect1, incorrect2;

  ShareDataFrd({this.percent1, this.percent2, this.time, this.correct1, this.incorrect1, this.correct2, this.incorrect2});
}

void saveScreenShot(RenderRepaintBoundary boundary, {Function? success, Function? fail}) {
  capturePng2List(boundary).then((unit8List) async {
    if(unit8List == null || unit8List.length == 0) {
      if (fail != null) fail();
      return;
    }
    Directory tempDir = await getApplicationDocumentsDirectory();
    print(tempDir.path);
    _saveImage(unit8List, tempDir, '/Score$count.png', success: success, fail: fail);
  });
}

void _saveImage(Uint8List unit8list, Directory dir, String fileName, {Function? success, Function? fail}) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  bool isDirExist = await Directory(dir.path).exists();
  if(!isDirExist) Directory(dir.path).create();
  String tempPath = '${dir.path}$fileName';
  File image = File(tempPath);
  bool isExist = await image.exists();
  if(isExist) await image.delete();

  File(tempPath).writeAsBytes(unit8list).then((_) {
    if(success != null) {
      print('imagePath: $tempPath');
      scoreImageList!.add(tempPath);
      pref.setStringList('editImage', scoreImageList!);
      pref.setInt('count', count!);
      count++;
      success(File(tempPath));
    }
  });
}

Future<Uint8List> capturePng2List(RenderRepaintBoundary boundary) async {
  ui.Image image = await boundary.toImage(pixelRatio: ui.window.devicePixelRatio);
  ByteData? byteData = await (image.toByteData(format: ui.ImageByteFormat.png));
  Uint8List pngBytes = byteData!.buffer.asUint8List();
  return pngBytes;
}

showSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

class GameInfo {
  String? player1Name, player2Name, noofquestion, p1Emoji, p2Emoji, operation, p1Score, p2Score;
  int? levelMode;
  int playTimeSec = 30;

  GameInfo({
    this.player1Name,
    this.player2Name,
    this.p1Emoji,
    this.p2Emoji,
    this.p1Score,
    this.p2Score,
    this.levelMode,
    this.noofquestion,
    this.operation,
    this.playTimeSec = 30,
  });
}

class ScoreBoardJson {
  List<Board> board = [];

  ScoreBoardJson({required this.board});

  ScoreBoardJson.fromJson(Map<String, dynamic> json) {
    if(json['Board'] != null) {
      board = <Board>[];
      json['Board'].forEach((v) {
        board.add(Board.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if(this.board != null) {
      data['Board'] = this.board.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Board {
  String? player1name;
  String? player2name;
  String? player1emoji;
  String? player2emoji;
  String? player1score;
  String? player2score;
  String? noofquestion;
  String? mode;
  String? operation;
  String? winner;
  String? datetime;

  Board({this.player1name, this.player2name, this.player1emoji, this.player2emoji, this.player1score, this.player2score, this.noofquestion, this.mode, this.operation, this.winner, this.datetime});

  Board.fromJson(Map<String, dynamic> json) {
    player1name = json['Player1name'];
    player2name = json['Player2name'];
    player1emoji = json['Player1emogi'];
    player2emoji = json['Player2emogi'];
    player1score = json['Player1score'];
    player2score = json['Player2score'];
    noofquestion = json['noofquestion'];
    mode = json['mode'];
    operation = json['operation'];
    winner = json['winner'];
    datetime = json['DateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Player1name'] = this.player1name;
    data['Player2name'] = this.player2name;
    data['Player1emogi'] = this.player1emoji;
    data['Player2emogi'] = this.player2emoji;
    data['Player1score'] = this.player1score;
    data['Player2score'] = this.player2score;
    data['noofquestion'] = this.noofquestion;
    data['mode'] = this.mode;
    data['operation'] = this.operation;
    data['winner'] = this.winner;
    data['DateTime'] = this.datetime;
    return data;
  }
}

