import 'package:flutter/animation.dart';

class Question {
  int? num1, num2, answer;
  String? operator;
  bool? isDone;
  Question({this.num1, this.num2, this.answer, this.operator, this.isDone});
}

class SimQuestion {
  int? answer;
  String? que;
  bool? isDone;
  List<int>? option;
  SimQuestion({this.answer, this.que, this.isDone, this.option});
}

class AlphaQuestion {
  String? answer;
  String? que;
  bool? isDone;
  List<String>? options;
  String? selectedAlpha;
  AlphaQuestion({this.que, this.answer, this.isDone, this.options, this.selectedAlpha});
}

class QuickAnim {
  AnimationController controller;
  Animation animation;
  AnimationStatus status;
  QuickAnim({required this.controller, required this.animation, required this.status});
}
