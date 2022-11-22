import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:pikpik/corn.dart';

import 'pikpik_controller.dart';

const tileSize = 16.0;
bool playerCanMove = true;
double life = 120;

class GamePlayer extends SimplePlayer with ObjectCollision, ChangeNotifier {
  late TimerComponent gameTimer;
  late TimerComponent yellowCornTimer;
  late TimerComponent blueCornTimer;
  late TimerComponent redCornTimer;
  late PikPikController gameController;
  late Random random;

  GamePlayer({required Vector2 position})
      : super(
          position: position,
          speed: tileSize * 7,
          size: Vector2(tileSize * 0.9, tileSize * 0.9),
          life: life,
          animation: SimpleDirectionAnimation(
            idleRight: PlayerSpriteSheet.playerIdleRight,
            idleLeft: PlayerSpriteSheet.playerIdleLeft,
            runRight: PlayerSpriteSheet.playerRunRight,
            runLeft: PlayerSpriteSheet.playerRunLeft,
          ),
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(tileSize - 2, tileSize - 7),
            align: Vector2(0, 3),
          ),
        ],
      ),
    );
  }

  @override
  void onMount() {
    gameController = BonfireInjector.instance.get();
    random = Random();

    /// Time countdown
    gameTimer = TimerComponent(
      autoStart: false,
      period: 1,
      repeat: true,
      onTick: () {
        gameController.decreaseTime();
      },
    );

    gameRef.add(gameTimer);
    gameTimer.timer.start();

    /// Yellow corn
    yellowCornTimer = TimerComponent(
      period: 2,
      repeat: true,
      onTick: () => addCornToWorld(CornType.yellow),
    );
    gameRef.add(yellowCornTimer);

    /// Blue corn
    blueCornTimer = TimerComponent(
      period: 5,
      repeat: true,
      onTick: () => addCornToWorld(CornType.blue),
    );
    gameRef.add(blueCornTimer);

    /// Red corn
    redCornTimer = TimerComponent(
      period: 15,
      repeat: true,
      onTick: () => addCornToWorld(CornType.red),
    );
    gameRef.add(redCornTimer);

    startCorn();

    super.onMount();
  }

  void stopCorn() {
    yellowCornTimer.timer.stop();
    blueCornTimer.timer.stop();
    redCornTimer.timer.stop();
  }

  void startCorn() {
    yellowCornTimer.timer.start();
    blueCornTimer.timer.start();
    redCornTimer.timer.start();
  }

  @override
  void update(double dt) {
    if (gameController.timeRemaining == 0 && gameController.isGameRunning) {
      idle();
      stopCorn();
      gameController.finishGame(context);
    } else if (gameController.isGameRunning &&
        !yellowCornTimer.timer.isRunning()) {
      startCorn();
    }

    super.update(dt);
  }

//Die
  @override
  void die() async {
    idle();
    stopCorn();
    gameController.finishGame(context);

    // final sprite = await PlayerSpriteSheet.simpleGrave;
    // gameRef.add(
    //   GameDecoration.withSprite(
    //     sprite: sprite.getSprite(),
    //     position: Vector2(position.x, position.y),
    //     size: Vector2.all(tileSize),
    //   ),
    // );

    super.die();
  }

  void addCornToWorld(CornType type) {
    if (!gameController.isGameRunning) return;

    /// The constraints of the map
    int xLimit = random.nextInt(42) + 2; // 2 to 43
    int yLimit = random.nextInt(17) + 2; // 2 to 18

    /// Additional value to avoid always centering corn in tiles
    double displacementX =
        random.nextDouble() * ((xLimit >= 40 || xLimit <= 2) ? 0.5 : 2.0);
    double displacementY =
        random.nextDouble() * ((yLimit >= 15 || xLimit <= 2) ? 0.5 : 2.0);

    /// Random operators to add or subtract the displacement
    bool isSum = random.nextInt(2) == 0;
    bool isSumAgain = random.nextInt(2) == 0;

    /// Final coordinates to add the corn
    double x = (isSum ? xLimit + displacementX : xLimit - displacementX)
        .clamp(1.5, 43.5);
    double y = (isSumAgain ? yLimit + displacementY : yLimit - displacementY)
        .clamp(1.5, 18.5);

    /// If the area is a map object, a new attempt will be made to add a corn
    /// In the case it is occupied again, well, this adds some more randomness to the game ;)
    if (isBlockedArea(x, y)) {
      // print('Position $x, $y is blocked, trying again...');
      addCornToWorld(type);
    } else {
      switch (type) {
        case CornType.yellow:
          gameRef.add(YellowCorn(Vector2(x * tileSize, y * tileSize)));
          break;

        case CornType.blue:
          gameRef.add(BlueCorn(Vector2(x * tileSize, y * tileSize)));
          break;

        case CornType.red:
          gameRef.add(RedCorn(Vector2(x * tileSize, y * tileSize)));
          break;
      }

      // print('${type.toString()} added at: $x, $y');
    }
  }

  bool isBlockedArea(double x, double y) {
    /// Fences on the left side of the map
    // Top
    if ((x >= 2 && x <= 9) && (y >= 2 && y <= 3)) return true;
    // Left
    if ((x >= 2 && x <= 3) && (y >= 2 && y <= 9)) return true;
    // Right
    if ((x >= 9 && x <= 10) && (y >= 2 && y <= 9)) return true;
    // Bottom left
    if ((x >= 2 && x <= 4.2) && (y >= 9 && y <= 10.5)) return true;
    // Bottom right
    if ((x >= 6.8 && x <= 9) && (y >= 9 && y <= 10.5)) return true;

    /// Tree on the left side of the map
    if ((x >= 2.5 && x <= 6) && (y >= 12 && y <= 16)) return true;

    /// House in the middle of the map
    if ((x >= 20 && x <= 26.8) && (y >= 4 && y <= 9)) return true;
    // Roof
    if ((x >= 21 && x <= 25) && (y >= 2 && y <= 5)) return true;
    // Last roof tile
    if ((x >= 23 && x <= 23.9) && (y >= 1.25 && y <= 3)) return true;

    /// Tree on the bottom right side of the map
    if ((x >= 28 && x <= 32) && (y >= 15 && y <= 19)) return true;

    /// Tree on the middle right side of the map
    if ((x >= 38.5 && x <= 42) && (y >= 7.8 && y <= 12)) return true;

    /// House on the top right side of the map
    if ((x >= 36.3 && x <= 42.6) && (y >= 1 && y <= 6)) return true;

    /// Fences on the right side of the map
    // Top left
    if ((x >= 30 && x <= 34) && (y >= 10 && y <= 11)) return true;
    // Top right
    if ((x >= 36 && x <= 40) && (y >= 10 && y <= 11)) return true;
    // Left
    if ((x >= 29.5 && x <= 31) && (y >= 10 && y <= 16)) return true;
    // Right
    if ((x >= 39 && x <= 40.5) && (y >= 10 && y <= 16)) return true;
    // Small conjunction left
    if ((x >= 30 && x <= 32) && (y >= 14.8 && y <= 16.25)) return true;
    // Small conjuction right
    if ((x >= 37 && x <= 39) && (y >= 14.8 && y <= 16.25)) return true;
    // Bottom left
    if ((x >= 32 && x <= 33.3) && (y >= 14.8 && y <= 18.5)) return true;
    // Bottom right
    if ((x >= 36.8 && x <= 38.2) && (y >= 14.8 && y <= 18.5)) return true;

    return false;
  }
}

class PlayerSpriteSheet {
  static Future<SpriteAnimation> get playerIdleLeft => SpriteAnimation.load(
        'player/chicken.png',
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: 1.0,
          textureSize: Vector2(16, 16),
          texturePosition: Vector2(0, 0),
        ),
      );
  static Future<SpriteAnimation> get playerIdleRight => SpriteAnimation.load(
        'player/chicken.png',
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: 1.0,
          textureSize: Vector2(16, 16),
          texturePosition: Vector2(0, 16),
        ),
      );
  static Future<SpriteAnimation> get playerRunLeft => SpriteAnimation.load(
        'player/chicken.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.15,
          textureSize: Vector2(16, 16),
          texturePosition: Vector2(0, 0),
        ),
      );
  static Future<SpriteAnimation> get playerRunRight => SpriteAnimation.load(
        'player/chicken.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.15,
          textureSize: Vector2(16, 16),
          texturePosition: Vector2(0, 16),
        ),
      );

  //Grave
  // static Future<SpriteAnimation> get simpleGrave => SpriteAnimation.load(
  //       'dying.png',
  //       SpriteAnimationData.sequenced(
  //         amount: 4,
  //         stepTime: 0.15,
  //         textureSize: Vector2(tileSize, tileSize),
  //         texturePosition: Vector2(0, 0),
  //       ),
  //     );
}
