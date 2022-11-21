import 'package:bonfire/bonfire.dart';
import 'pikpik_controller.dart';

const tileSize = 16.0;

class Aunt extends SimpleEnemy with ObjectCollision, AutomaticRandomMovement {
  late PikPikController gameController;

  Aunt({required Vector2 position})
      : super(
          position: position,
          speed: 40,
          size: Vector2(tileSize, tileSize),
          animation: SimpleDirectionAnimation(
            idleRight: AuntSpritesheet.enemyIdleRight,
            idleLeft: AuntSpritesheet.enemyIdleLeft,
            runRight: AuntSpritesheet.enemyRunRight,
            runLeft: AuntSpritesheet.enemyRunLeft,
          ),
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(tileSize - 10, tileSize - 10),
            align: Vector2(5, 11),
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
  static Future<SpriteAnimation> get enemyIdleLeft => SpriteAnimation.load(
        'player/chicken.png',
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: 1.0,
          textureSize: Vector2(16, 16),
          texturePosition: Vector2(0, 0),
        ),
      );
  static Future<SpriteAnimation> get enemyIdleRight => SpriteAnimation.load(
        'player/chicken.png',
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: 1.0,
          textureSize: Vector2(16, 16),
          texturePosition: Vector2(0, 16),
        ),
      );

  static Future<SpriteAnimation> get enemyRunLeft => SpriteAnimation.load(
        'player/chicken.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.25,
          textureSize: Vector2(16, 16),
          texturePosition: Vector2(0, 0),
        ),
      );
  static Future<SpriteAnimation> get enemyRunRight => SpriteAnimation.load(
        'player/chicken.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.25,
          textureSize: Vector2(16, 16),
          texturePosition: Vector2(0, 16),
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
