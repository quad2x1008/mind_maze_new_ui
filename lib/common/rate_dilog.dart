import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'EntryAnimation.dart';

/// Defines variants of entry animations

class RateDialog extends StatefulWidget {
  RateDialog({
    Key? key,
    required this.imageWidget,
    required this.title,
    required this.onOkButtonPressed,
    required this.description,
    this.onCancelButtonPressed,
    this.onNeutralButtonPressed,
    this.onlyOkButton = false,
    this.isNeutralButton = false,
    this.onlyCancelButton = false,
    this.buttonOkText,
    this.buttonCancelText,
    this.buttonOkColor = Colors.transparent,
    this.buttonCancelColor = Colors.transparent,
    this.buttonNeutralColor = Colors.redAccent,
    this.cornerRadius = 10.0,
    this.buttonRadius = 8.0,
    this.entryAnimation = EntryAnimation.DEFAULT,
  }) : super(key: key);

  final Widget imageWidget;
  final Widget title;
  final Widget description;
  final bool onlyOkButton;
  final bool isNeutralButton;
  final bool onlyCancelButton;
  final Text? buttonOkText;
  final Text? buttonCancelText;
  final Color buttonOkColor;
  final Color buttonCancelColor;
  final Color buttonNeutralColor;
  final double buttonRadius;
  final double cornerRadius;
  final VoidCallback? onOkButtonPressed;
  final VoidCallback? onCancelButtonPressed;
  final VoidCallback? onNeutralButtonPressed;
  final EntryAnimation entryAnimation;

  @override
  _RateDialogState createState() => _RateDialogState();
}

class _RateDialogState extends State<RateDialog> with TickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<Offset>? _entryAnimation;

  get _start {
    switch (widget.entryAnimation) {
      case EntryAnimation.DEFAULT:
        break;
      case EntryAnimation.TOP:
        return Offset(0.0, -1.0);
      case EntryAnimation.TOP_LEFT:
        return Offset(-1.0, -1.0);
      case EntryAnimation.TOP_RIGHT:
        return Offset(1.0, -1.0);
      case EntryAnimation.LEFT:
        return Offset(-1.0, 0.0);
      case EntryAnimation.RIGHT:
        return Offset(1.0, 0.0);
      case EntryAnimation.BOTTOM:
        return Offset(0.0, 1.0);
      case EntryAnimation.BOTTOM_LEFT:
        return Offset(-1.0, 1.0);
      case EntryAnimation.BOTTOM_RIGHT:
        return Offset(1.0, 1.0);
    }
  }

  get _isDefaultEntryAnimation => widget.entryAnimation == EntryAnimation.DEFAULT;

  @override
  void initState() {
    super.initState();
    if (!_isDefaultEntryAnimation) {
      _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
      _entryAnimation = Tween<Offset>(begin: _start, end: Offset(0.0, 0.0)).animate(
        CurvedAnimation(
          parent: _animationController!,
          curve: Curves.easeIn,
        ),
      )..addListener(() => setState(() {}));
      _animationController!.forward();
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  Widget _buildPortraitWidget(BuildContext context, Widget imageWidget) {
    return Container(
      padding: EdgeInsets.fromLTRB(30.r, 20.r, 30.r, 40.r),
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/Game/fcard.png"), fit: BoxFit.fill)),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: widget.title,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.description,
              ),
              _buildButtonsBar(context)
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(widget.cornerRadius)),
            child: imageWidget,
          ),
        ],
      ),
    );
  }

  Widget _buildButtonsBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: !widget.onlyOkButton ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
        children: <Widget>[
          if (!widget.onlyOkButton) ...[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.buttonCancelColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.buttonRadius),
                ),
              ),
              onPressed: widget.onCancelButtonPressed ?? () => Navigator.of(context).pop(),
              child: widget.buttonCancelText ?? Text('Cancel', style: TextStyle(color: Colors.white)),
            )
          ],
          if (widget.isNeutralButton) ...[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.buttonNeutralColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.buttonRadius)),
              ),
              onPressed: widget.onNeutralButtonPressed ?? () => Navigator.of(context).pop(),
              child: widget.buttonCancelText ?? Text('I hate it!', style: TextStyle(color: Colors.white)),
            )
          ],
          if (!widget.onlyCancelButton) ...[
            GestureDetector(
              onTap: widget.onOkButtonPressed,
              child: Container(
                height: 35.h,
                width: 100.w,
                decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/Game/btn_bg2.png"), fit: BoxFit.fill)),
                margin: EdgeInsets.all(3.r),
                child: Center(
                  child: Text("SUBMIT",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.sp, letterSpacing: 3),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        transform: !_isDefaultEntryAnimation
            ? Matrix4.translationValues(_entryAnimation!.value.dx * width, _entryAnimation!.value.dy * width, 0)
            : null,
        width: MediaQuery.of(context).size.width / 1.1 * (isPortrait ? 0.8 : 0.6),
        child: Material(
          type: MaterialType.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.cornerRadius)),
          color: Colors.transparent,
          elevation: Theme.of(context).dialogTheme.elevation ?? 24.0,
          child: _buildPortraitWidget(context, widget.imageWidget),
        ),
      ),
    );
  }
}
