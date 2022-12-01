import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:pikpik/aunt.dart';
import 'package:pikpik/fancy_button.dart';

import 'sounds_manager.dart';

class PikPikController extends ChangeNotifier {
  static const int kGameTime = 120;

  late BonfireGame _game;
  BonfireGame get game => _game;

  int _points = 0;
  int _timeRemaining = kGameTime;
  bool _isGameRunning = true;
  bool _lockMove = false;

  int get points => _points;
  int get timeRemaining => _timeRemaining;
  bool get isGameRunning => _isGameRunning;
  bool get lockMove => _lockMove;

  void setGame(BonfireGame game) {
    _game = game;
    notifyListeners();
  }

  void incrementPoints({int count = 1}) {
    _points += count;
    notifyListeners();
  }

  void decreaseTime({int count = 1}) {
    if (timeRemaining == 0 || !_isGameRunning) return;
    _timeRemaining -= count;
    notifyListeners();
  }

  void finishGame(BuildContext context) {
    _isGameRunning = false;
    _timeRemaining = 0;
    showPlayAgainPopup(context);
    notifyListeners();
  }

  void restartGame(BuildContext context) {
    _points = 0;
    _timeRemaining = kGameTime;
    _lockMove = true;
    notifyListeners();
    Navigator.pop(context);
    game.player!.revive();
    game.player!.idle();
    game.camera.moveToPlayerAnimated();
    game.player!.position = Vector2(23 * 16, 10 * 16);
    game.enemies().forEach((element) {
      element.removeFromParent();
    });
    game.decorations().forEach((element) {
      element.removeFromParent();
    });
    game.add(Aunt(position: Vector2(35 * 16, 13 * 16)));
    game.add(Aunt(position: Vector2(40 * 16, 7 * 16)));
    game.add(Aunt(position: Vector2(6 * 16, 6 * 16)));
    game.add(Aunt(position: Vector2(4 * 16, 16 * 16)));
    game.overlayManager.add('timer');
    Future.delayed(const Duration(seconds: 3), () {
      SoundsManager.resumeBgm();
      game.overlayManager.remove('timer');
      _isGameRunning = true;
      _lockMove = false;
      notifyListeners();
    });
  }

  void showPlayAgainPopup(BuildContext context) {
    showGeneralDialog(
      barrierDismissible: false,
      barrierColor: Colors.black26,
      context: context,
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(1, 0), end: const Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
      pageBuilder: (context, anim1, anim2) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(width: 5.0, color: Colors.amber),
              ),
              height: 200,
              width: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total points: $_points',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FancyButton(
                    color: Colors.green,
                    size: 50.0,
                    onPressed: () {
                      restartGame(context);
                    },
                    child: const Text(
                      'Play again',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
