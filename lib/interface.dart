import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

import 'pikpik_controller.dart';

class PlayerInterface extends StatefulWidget {
  final BonfireGame game;

  const PlayerInterface({Key? key, required this.game}) : super(key: key);

  @override
  State<PlayerInterface> createState() => _PlayerInterfaceState();
}

class _PlayerInterfaceState extends State<PlayerInterface> {
  late PikPikController gameController;

  void _listener() {
    if (mounted) {
      Future.delayed(Duration.zero, () {
        setState(() {});
      });
    }
  }

  @override
  void initState() {
    gameController = BonfireInjector.instance.get();
    gameController.addListener(_listener);
    (widget.game.player as ChangeNotifier?)?.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    gameController.removeListener(_listener);
    (widget.game.player as ChangeNotifier?)?.removeListener(_listener);
    super.dispose();
  }

  String formatTime(int time) {
    int sec = time % 60;
    int min = (time / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
  }

  @override
  Widget build(BuildContext context) {
    final points = gameController.points.toString();
    final time = formatTime(gameController.timeRemaining);
    return SafeArea(
      child: Container(
        color: Colors.transparent,
        width: 300,
        height: 100,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                points,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
