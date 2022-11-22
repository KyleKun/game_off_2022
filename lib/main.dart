import 'package:flutter/material.dart';

import 'package:bonfire/bonfire.dart';
import 'package:pikpik/interface.dart';

import 'aunt.dart';
import 'game_player.dart';
import 'pikpik_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BonfireInjector.instance.put((i) => PikPikController());
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> implements GameListener {
  late PikPikController gameController;
  late GameController controller;

  @override
  void initState() {
    gameController = BonfireInjector.instance.get();
    controller = GameController()..addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            // moveOnlyMapArea: true,
            smoothCameraEnabled: true,
            zoom: 3.5,
          ),

          initialActiveOverlays: const [
            'points',
          ],
          overlayBuilderMap: {
            'points': ((context, game) => PlayerInterface(game: game)),
            'timer': ((context, game) => TimerInterface(game: game)),
          },
          showCollisionArea: true,
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

          // Lighting
          // lightingColorGame: Colors.black.withOpacity(0.15),
        ),
      ),
    );
  }

  @override
  void changeCountLiveEnemies(int count) {}

  @override
  void updateGame() {}
}
