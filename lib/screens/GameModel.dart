
import 'package:mind_maze/common/Key.dart';

enum Game {
  OPERATIONS,
  SIMPLICITY,
  ColorOfDeception,
  FlickMaster,
  Addition,
  HighORLow,
  AdditionLink,
  AlphabetSkip,
  BirdWatching,
  QuickEye,
  RapidSorting,
  SpinningBlock,
  TapTheColor,
  CardCalculation,
  FollowTheLeader,
  UnfollowTheLeader,
  TouchNumber,
  Matching,
  FindQuest,
  ChromaShapes,
  ColorSense,
  NumberSorter,
  PicMatch,
  StopTheBall,
  ColorQuest,
  ShapesQuest,
  VisualMastery
}

List<GameModel> gameModelList = [
  GameModel(gameId: 1, id: Game.OPERATIONS, gameTitle: "Operations", sessinKey: KEY.KEY_OperationsStar, Training_icon: "assets/icon/ope_icon.png", Training_tips: "assets/icon/ope_tips.png", tipsText: "Choose the correct arithmetic operations.", eqText: "6 ? 5 = 30",isLock: false),
  GameModel(gameId: 2, id: Game.SIMPLICITY, gameTitle: "Simplicity", sessinKey: KEY.KEY_SimplicityStar, Training_icon: "assets/icon/sim_icon.png", Training_tips: "assets/icon/sim_tips.png", tipsText: "Choose the correct answer.", eqText: "8+(6-3)", isLock: true),
  GameModel(gameId: 3, id: Game.ColorOfDeception, gameTitle: "Color of Deception", sessinKey: KEY.KEY_ColorDeceptionStar, Training_icon: "assets/icon/color_icon.png", Training_tips: "assets/icon/color_tips.png", tipsText: "Choose the color that doesn't belong.", eqText: "", isLock: true),
  GameModel(gameId: 4, id: Game.FlickMaster, gameTitle: "Flick Master", sessinKey: KEY.KEY_FlickMasterStar, Training_icon: "assets/icon/flick_icon.png", Training_tips: "assets/icon/flick_tips.png", tipsText: "Blue : Follow the arrow. \n Red : Unfollow the arrow.", eqText: "", isLock: true),
  GameModel(gameId: 5, id: Game.Addition, gameTitle: "Addition Addiction", sessinKey: KEY.KEY_AdditionAddictionStar, Training_icon: "assets/icon/add_icon.png", Training_tips: "assets/icon/add_tips.png", tipsText: "Sum up panels equal to \n the indicated number.", eqText: "", isLock: true),
  GameModel(gameId: 6, id: Game.HighORLow, gameTitle: "High or Low", sessinKey: KEY.KEY_HighOrLowStar, Training_icon: "assets/icon/hl_icon.png", Training_tips: "assets/icon/hl_tips.png", tipsText: "Greater than the previous : Swipe up \n Less than the previous : Swipe down", eqText: "", isLock: true),
  GameModel(gameId: 7, id: Game.AdditionLink, gameTitle: "Addition Link", sessinKey: KEY.KEY_AdditionLinkStar, Training_icon: "assets/icon/add_link_icon.png", Training_tips: "assets/icon/add_link_tips.png", tipsText: "Drag Through the numbers \n to make the indicated value.", eqText: "12", isLock: true),
  GameModel(gameId: 8, id: Game.AlphabetSkip, gameTitle: "Alphabet Skip", sessinKey: KEY.KEY_AlphabetSkipStar, Training_icon: "assets/icon/alpha_icon.png", Training_tips: "assets/icon/alpha_tips.png", tipsText: "Choose the correct alphabet.", eqText: "A Skip 2 = ?", isLock: true),
  GameModel(gameId: 9, id: Game.BirdWatching, gameTitle: "Bird Watching", sessinKey: KEY.KEY_BirdWatchingStar, Training_icon: "assets/icon/bird_icon.png", Training_tips: "assets/icon/bird_tips.png", tipsText: "Tap the color that appears the most.", eqText: "", isLock: true),
  GameModel(gameId: 10, id: Game.QuickEye, gameTitle: "Quick Eye", sessinKey: KEY.KEY_QuickEyeStar, Training_icon: "assets/icon/quick_icon.png", Training_tips: "assets/icon/quick_tips.png", tipsText: "Find an identical card to the one displayed.", eqText: "",isLock: true),
  GameModel(gameId: 11, id: Game.RapidSorting, gameTitle: "Rapid Sorting", sessinKey: KEY.KEY_RapidSortingStar, Training_icon: "assets/icon/rapid_icon.png", Training_tips: "assets/icon/rapid_tips.png", tipsText: "Same shape : Swipe the same direction.\n Different shape : Opposite direction.", eqText: "",isLock: true),
  GameModel(gameId: 12, id: Game.SpinningBlock, gameTitle: "Spinning Block", sessinKey: KEY.KEY_SpinningBlockStar, Training_icon: "assets/icon/spin_icon.png", Training_tips: "assets/icon/spin_tips.png", tipsText: "1. Memorize the blue block locations. \n 2. Tap after the blocks spin", eqText: "",isLock: true),
  GameModel(gameId: 13, id: Game.TapTheColor, gameTitle: "Tap The Color", sessinKey: KEY.KEY_TapTheColorStar, Training_icon: "assets/icon/tap_icon.png", Training_tips: "assets/icon/tap_tips.png", tipsText: "1. Memorize the location of each color. \n 2. Tap in the displayed order.", eqText: "",isLock: true),
  GameModel(gameId: 14, id: Game.CardCalculation, gameTitle: "Card Calculation", sessinKey: KEY.KEY_CardCalculationStar, Training_icon: "assets/icon/card_icon.png", Training_tips: "assets/icon/card_tips.png", tipsText: "1. Add up if blue, subtract if red. \n 2. Select the answer.", eqText: "",isLock: true),
  GameModel(gameId: 15, id: Game.FollowTheLeader, gameTitle: "Follow The Leader", sessinKey: KEY.KEY_FollowLeaderStar, Training_icon: "assets/icon/follow_icon.png", Training_tips: "assets/icon/follow_tips.png", tipsText: "Tap the blocks in the order \n they appeared", eqText: "",isLock: true),
  GameModel(gameId: 16, id: Game.UnfollowTheLeader, gameTitle: "Unfollow The Leader", sessinKey: KEY.KEY_UnfollowLeaderStar, Training_icon: "assets/icon/unfollow_icon.png", Training_tips: "assets/icon/unfollow_tips.png", tipsText: "Tap the blocks in the opposite \n order they appeared", eqText: "",isLock: true),
  GameModel(gameId: 17, id: Game.TouchNumber, gameTitle: "Touch Number +", sessinKey: KEY.KEY_TouchNumberStar, Training_icon: "assets/icon/touch_icon.png", Training_tips: "assets/icon/touch_tips.png", tipsText: "1. Tap in an ascending order. \n 2. Select the sum of the number.", eqText: "",isLock: true),
  GameModel(gameId: 18, id: Game.Matching, gameTitle: "Matching", sessinKey: KEY.KEY_MatchingStar, Training_icon: "assets/icon/match_icon.png", Training_tips: "assets/icon/match_tips.png", tipsText: "Find the matching pair.", eqText: "",isLock: true),
  GameModel(gameId: 19, id: Game.FindQuest, gameTitle: "Find Quest", sessinKey: KEY.KEY_FindQuestStar, Training_icon: "assets/icon/find_icon.png", Training_tips: "assets/icon/find_tips.png", tipsText: "Choose the different image from list", eqText: "", isLock: true),
  GameModel(gameId: 20, id: Game.ChromaShapes, gameTitle: "Chroma Shapes", sessinKey: KEY.KEY_ChromaShapesStar, Training_icon: "assets/icon/chroma_icon.png", Training_tips: "assets/icon/chroma_tips.png", tipsText: "Choose if the statement is correct or not", eqText: "", isLock: true),
  GameModel(gameId: 21, id: Game.ColorSense, gameTitle: "Color Sense", sessinKey: KEY.KEY_ColorSenseStar, Training_icon: "assets/icon/sense_icon.png", Training_tips: "assets/icon/sense_tips.png", tipsText: "Choose the correct answer from the list", eqText: "", isLock: true),
  GameModel(gameId: 22, id: Game.NumberSorter, gameTitle: "Number Sorter", sessinKey: KEY.KEY_NumberSorterStar, Training_icon: "assets/icon/number_icon.png", Training_tips: "assets/icon/number_tips.png", tipsText: "Number shorting in ascending order", eqText: "", isLock: true),
  GameModel(gameId: 23, id: Game.PicMatch, gameTitle: "Pic Match", sessinKey: KEY.KEY_PicMatchStar, Training_icon: "assets/icon/pic_icon.png", Training_tips: "assets/icon/pic_tips.png", tipsText: "Find all the cards that match", eqText: "", isLock: true),
  GameModel(gameId: 24, id: Game.StopTheBall, gameTitle: "Stop The Ball", sessinKey: KEY.KEY_StopTheBallStar, Training_icon: "assets/icon/stop_icon.png", Training_tips: "assets/icon/stop_tips.png", tipsText: "Stop the ball to reach the target", eqText: "", isLock: true),
  GameModel(gameId: 25, id: Game.ColorQuest, gameTitle: "Color Quest", sessinKey: KEY.KEY_ColorQuestStar, Training_icon: "assets/icon/find_color_icon.png", Training_tips: "assets/icon/find_color_tips.png", tipsText: "Find and tap the different color", eqText: "", isLock: true),
  GameModel(gameId: 26, id: Game.ShapesQuest, gameTitle: "Shapes Quest", sessinKey: KEY.KEY_ShapesQuestStar, Training_icon: "assets/icon/shapes_icon.png", Training_tips: "assets/icon/shapes_tips.png", tipsText: "Choose the different image", eqText: "", isLock: true),
  GameModel(gameId: 27, id: Game.VisualMastery, gameTitle: "Visual Mastery", sessinKey: KEY.KEY_VisualMasteryStar, Training_icon: "assets/icon/visual_icon.png", Training_tips: "assets/icon/visual_tips.png", tipsText: "Count how many times every picture appears", eqText: "", isLock: true)
];

class GameModel{
  int gameId;
  Game id;
  String gameTitle = "";
  String Training_icon = "assets/icon/ope_icon.png";
  String Training_tips = "assets/icon/ope_tips.png";
  String tipsText = "Choose the correct arithmetic operations.";
  String eqText = "6 + 5";
  int? totalScore = 0;
  bool isLock = false;
  int playTimeSec = 30;
  String sessinKey = "";

  GameModel({
    required this.gameId,
    required this.id,
    required this.gameTitle,
    required this.Training_icon,
    required this.Training_tips,
    required this.tipsText,
    required this.eqText,
    this.totalScore,
    this.isLock = false,
    this.playTimeSec = 30,
    this.sessinKey = "",
  });
}

