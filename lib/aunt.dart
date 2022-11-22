import 'package:bonfire/bonfire.dart';
import 'pikpik_controller.dart';

const tileSize = 24.0;

class Aunt extends SimpleEnemy with ObjectCollision, AutomaticRandomMovement {
  late PikPikController gameController;

  Aunt({required Vector2 position})
      : super(
          position: position,
          speed: 40,
          size: Vector2(tileSize, tileSize),
          animation: SimpleDirectionAnimation(
            idleDown: AuntSpritesheet.enemyIdleDown,
            idleUp: AuntSpritesheet.enemyIdleUp,
            idleRight: AuntSpritesheet.enemyIdleRight,
            idleLeft: AuntSpritesheet.enemyIdleLeft,
            runRight: AuntSpritesheet.enemyRunRight,
            runLeft: AuntSpritesheet.enemyRunLeft,
            runDown: AuntSpritesheet.enemyRunDown,
            runUp: AuntSpritesheet.enemyRunUp,
          ),
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(tileSize / 2, tileSize / 1.5),
            align: Vector2(5, 5),
          ),
        ],
      ),
    );
  }

  @override
  void onMount() {
    gameController = BonfireInjector.instance.get();
    super.onMount();
  }

  @override
  void update(double dt) {
    seePlayer(
      observed: (player) {
        if (gameController.isGameRunning) {
          seeAndMoveToPlayer(
            closePlayer: (player) {
              simpleAttackMelee(
                damage: 999,
                size: Vector2.all(tileSize),
                //animationRight: AuntSpritesheet.attackRight,
              );
            },
            radiusVision: tileSize * 4,
            margin: 4,
          );
        }
      },
      notObserved: () {
        runRandomMovement(dt);
      },
      radiusVision: tileSize * 4,
    );

    super.update(dt);
  }
}

class AuntSpritesheet {
  static const runIdleSpritesheet = 'enemy/aunt/aunt_run_idle_spritesheet.png';
  static Future<SpriteAnimation> get enemyRunRight => SpriteAnimation.load(
        runIdleSpritesheet,
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.15,
          textureSize: Vector2(32, 32),
          texturePosition: Vector2(0, 0),
        ),
      );

  static Future<SpriteAnimation> get enemyRunLeft => SpriteAnimation.load(
        runIdleSpritesheet,
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.15,
          textureSize: Vector2(32, 32),
          texturePosition: Vector2(128, 0),
        ),
      );

  /// enemy run up
  static Future<SpriteAnimation> get enemyRunUp => SpriteAnimation.load(
        runIdleSpritesheet,
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.15,
          textureSize: Vector2(32, 32),
          texturePosition: Vector2(256, 0),
        ),
      );

  /// enemy run down
  static Future<SpriteAnimation> get enemyRunDown => SpriteAnimation.load(
        runIdleSpritesheet,
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.15,
          textureSize: Vector2(32, 32),
          texturePosition: Vector2(384, 0),
        ),
      );

  static Future<SpriteAnimation> get enemyIdleRight => SpriteAnimation.load(
        runIdleSpritesheet,
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.15,
          textureSize: Vector2(32, 32),
          texturePosition: Vector2(514, 0),
        ),
      );

  static Future<SpriteAnimation> get enemyIdleLeft => SpriteAnimation.load(
        runIdleSpritesheet,
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.15,
          textureSize: Vector2(32, 32),
          texturePosition: Vector2(642, 0),
        ),
      );

  /// enemy idle up
  static Future<SpriteAnimation> get enemyIdleUp => SpriteAnimation.load(
        runIdleSpritesheet,
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.15,
          textureSize: Vector2(32, 32),
          texturePosition: Vector2(770, 0),
        ),
      );

  /// enemy idle down
  static Future<SpriteAnimation> get enemyIdleDown => SpriteAnimation.load(
        runIdleSpritesheet,
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.15,
          textureSize: Vector2(32, 32),
          texturePosition: Vector2(898, 0),
        ),
      );

  // Attack
  // static Future<SpriteAnimation> get atackRight => SpriteAnimation.load(
  //       'attack_effect_right.png',
  //       SpriteAnimationData.sequenced(
  //         amount: 4,
  //         stepTime: 0.15,
  //         textureSize: Vector2(16, 16),
  //       ),
  //     );
}
