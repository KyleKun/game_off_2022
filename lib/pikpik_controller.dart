import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:pikpik/aunt.dart';

class PikPikController extends ChangeNotifier {
  static const int kGameTime = 150;

  late BonfireGame _game;
  BonfireGame get game => _game;

  int _points = 0;
  int _timeRemaining = kGameTime;
  bool _isGameRunning = true;

  int get points => _points;
  int get timeRemaining => _timeRemaining;
  bool get isGameRunning => _isGameRunning;

  void setGame(BonfireGame game) {
    _game = game;
    notifyListeners();
  }

  void incrementPoints({int count = 1}) {
    _points += count;
    notifyListeners();
  }

  void decreaseTime({int count = 1}) {
    if (timeRemaining == 0) return;
    if (!_isGameRunning) _timeRemaining = 1;
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
    _isGameRunning = true;
    notifyListeners();
    Navigator.pop(context);
    game.player!.revive();
    game.player!.idle();
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
                color: Colors.amberAccent,
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(width: 5.0, color: Colors.pinkAccent),
              ),
              height: 200,
              width: 500,
              child: Column(
                children: [
                  Text(
                    'Total points: $_points',
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      restartGame(context);
                    },
                    child: const Text('Play again'),
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
