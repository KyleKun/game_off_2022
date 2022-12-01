import 'dart:math';

import 'package:flutter/material.dart';

import 'package:bonfire/bonfire.dart';
import 'package:pikpik/interface.dart';
import 'package:pikpik/sounds_manager.dart';

import 'aunt.dart';
import 'game_player.dart';
import 'pikpik_controller.dart';

class MyGame extends StatefulWidget {
  const MyGame({Key? key}) : super(key: key);

  @override
  State<MyGame> createState() => _MyGameState();
}

class _MyGameState extends State<MyGame> implements GameListener {
  late PikPikController gameController;
  late GameController controller;

  @override
  void initState() {
    gameController = BonfireInjector.instance.get();
    controller = GameController()..addListener(this);
    Future.delayed(const Duration(seconds: 2), (() => SoundsManager.playBgm()));
    super.initState();
  }

  @override
  void dispose() {
    SoundsManager.stopBgm();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double heightMin = min(size.height, size.width) * 2.5;
    const tileSize = 16;

    return Material(
      child: Scaffold(
        body: BonfireWidget(
          onReady: (BonfireGame game) {
            gameController.setGame(game);
          },
          gameController: controller,

          //Camera
          cameraConfig: CameraConfig(
            moveOnlyMapArea: true,
            smoothCameraEnabled: true,
            smoothCameraSpeed: 2.0,
            zoom: 3.75,
            sizeMovementWindow: Vector2(heightMin / 10, 50),
          ),

          initialActiveOverlays: const [
            'points',
          ],
          overlayBuilderMap: {
            'points': ((context, game) => PlayerInterface(game: game)),
            'timer': ((context, game) => TimerInterface(game: game)),
          },
          //showCollisionArea: true,
          //Joystick
          joystick: Joystick(
            keyboardConfig: KeyboardConfig(
              enable: true,
              keyboardDirectionalType: KeyboardDirectionalType.wasdAndArrows,
            ),
          ),
          //Map Render
          map: WorldMapByTiled(
            'tiled/map.json',
            objectsBuilder: {
              'aunt': (properties) => Aunt(position: properties.position),
              'grandma': (properties) => Aunt(position: properties.position),
              'grandpa': (properties) => Aunt(position: properties.position),
              'dog': (properties) => Aunt(position: properties.position),
            },
          ),
          //Player
          player: GamePlayer(
            position: Vector2(tileSize * 23, tileSize * 10),
          ),

          //Lighting
          lightingColorGame: Colors.black.withOpacity(0.05),
        ),
      ),
    );
  }

  @override
  void changeCountLiveEnemies(int count) {}

  @override
  void updateGame() {}
}
