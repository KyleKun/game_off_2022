import 'package:flutter/material.dart';

class FancyButton extends StatefulWidget {
  const FancyButton({
    Key? key,
    required this.child,
    required this.size,
    required this.color,
    this.duration = const Duration(milliseconds: 200),
    required this.onPressed,
  }) : super(key: key);

  final Widget child;
  final Color color;
  final Duration duration;
  final VoidCallback onPressed;
  final double size;

  @override
  FancyButtonState createState() => FancyButtonState();
}

class FancyButtonState extends State<FancyButton>
    with TickerProviderStateMixin {
  bool choiceDone = false;
  AnimationController? _animationController;
  Animation<double>? _pressedAnimation;

  bool _isHovered = false;
  bool _isFocused = false;

  late TickerFuture _downTicker;

  double get buttonDepth => widget.size * 0.2;

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setupAnimation();
  }

  void _setupAnimation() {
    _animationController?.stop();
    final oldControllerValue = _animationController?.value ?? 0.0;
    _animationController?.dispose();
    _animationController = AnimationController(
      duration: Duration(microseconds: widget.duration.inMicroseconds ~/ 2),
      vsync: this,
      value: oldControllerValue,
    );
    _pressedAnimation = Tween<double>(begin: -buttonDepth, end: 0.0).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(FancyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _setupAnimation();
    }
  }

  void _onTapDown(_) {
    _downTicker = _animationController!.animateTo(1.0);
  }

  void _onTapUp(_) {
    _downTicker.whenComplete(() {
      _animationController!.animateTo(0.0);
      //SoundsManager.playSfx(sfx: 'button_click.wav');
      widget.onPressed.call();
    });
  }

  void _onTapCancel() {
    _animationController!.reset();
  }

  @override
  Widget build(BuildContext context) {
    final vertPadding = widget.size * 0.25;
    final horzPadding = widget.size * 0.50;
    final radius = BorderRadius.circular(horzPadding * 0.5);
    Color outlineColor = Colors.white;
    Color shadowColor = _isHovered ? Colors.white : Colors.transparent;

    return FocusableActionDetector(
      mouseCursor: SystemMouseCursors.click,
      onShowHoverHighlight: (v) => setState(() {
        _isHovered = v;
        _isFocused = v;
      }),
      child: Container(
        padding: const EdgeInsets.only(bottom: 2, left: 0.5, right: 0.5),
        decoration: BoxDecoration(
          color: outlineColor,
          borderRadius: radius,
          boxShadow: [
            BoxShadow(blurRadius: 20, color: shadowColor),
          ],
        ),
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: _hslRelativeColor(s: -0.20, l: -0.20),
                      borderRadius: radius,
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _pressedAnimation!,
                    builder: (BuildContext context, Widget? child) {
                      return Transform.translate(
                        offset: Offset(0.0, _pressedAnimation!.value),
                        child: child,
                      );
                    },
                    child: ClipRRect(
                      borderRadius: radius,
                      child: Stack(
                        children: <Widget>[
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: _hslRelativeColor(l: 0.02),
                              borderRadius: radius,
                            ),
                            child: const SizedBox.expand(),
                          ),
                          Transform.translate(
                            offset: Offset(0.0, vertPadding),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: _hslRelativeColor(),
                                borderRadius: radius,
                              ),
                              child: const SizedBox.expand(),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: vertPadding,
                              horizontal: horzPadding,
                            ),
                            child: widget.child,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _hslRelativeColor({double h = 0.0, s = 0.0, l = 0.0}) {
    final hslColor = HSLColor.fromColor(widget.color);
    h = (hslColor.hue + h).clamp(0.0, 360.0);
    s = (hslColor.saturation + s).clamp(0.0, 1.0);
    l = (hslColor.lightness + l).clamp(0.0, 1.0);
    return HSLColor.fromAHSL(hslColor.alpha, h, s, l).toColor();
  }
}
