import 'package:bonfire/bonfire.dart';
import 'package:pikpik/game_player.dart';

enum CornType {
  yellow,
  blue,
  red,
}

class YellowCorn extends GameDecoration with Sensor {
  YellowCorn(Vector2 position)
      : super.withAnimation(
          animation: CommonSpriteSheet.yellowCorn,
          position: position,
          size: Vector2.all(16 * 0.65),
        );

  @override
  void onMount() {
    add(
      TimerComponent(
        period: 20,
        onTick: () => removeFromParent(),
      ),
    );
    super.onMount();
  }

  @override
  void onContact(GameComponent component) {
    if (component is GamePlayer) {
      component.gameController.incrementPoints();
      removeFromParent();
    }
  }

  @override
  void onContactExit(GameComponent component) {}
}

class BlueCorn extends GameDecoration with Sensor {
  BlueCorn(Vector2 position)
      : super.withAnimation(
          animation: CommonSpriteSheet.blueCorn,
          position: position,
          size: Vector2.all(16 * 0.65),
        ) {
    setupSensorArea(intervalCheck: 50);
  }

  @override
  void onMount() {
    add(
      TimerComponent(
        period: 15,
        onTick: () => removeFromParent(),
      ),
    );
    super.onMount();
  }

  @override
  void onContact(GameComponent component) {
    if (component is GamePlayer) {
      component.gameController.incrementPoints(count: 5);
      removeFromParent();
    }
  }

  @override
  void onContactExit(GameComponent component) {}
}

class RedCorn extends GameDecoration with Sensor {
  RedCorn(Vector2 position)
      : super.withAnimation(
          animation: CommonSpriteSheet.redCorn,
          position: position,
          size: Vector2.all(16 * 0.65),
        );

  @override
  void onMount() {
    add(
      TimerComponent(
        period: 10,
        onTick: () => removeFromParent(),
      ),
    );
    super.onMount();
  }

  @override
  void onContact(GameComponent component) {
    if (component is GamePlayer) {
      component.gameController.incrementPoints(count: 20);
      removeFromParent();
    }
  }

  @override
  void onContactExit(GameComponent component) {}
}

class CommonSpriteSheet {
  /// Yellow corn
  static Future<SpriteAnimation> get yellowCorn => SpriteAnimation.load(
        'corn/yellow_corn.png',
        SpriteAnimationData.sequenced(
          amount: 5,
          textureSize: Vector2(16, 16),
          stepTime: 0.1,
        ),
      );

  /// Blue corn
  static Future<SpriteAnimation> get blueCorn => SpriteAnimation.load(
        'corn/blue_corn.png',
        SpriteAnimationData.sequenced(
          amount: 5,
          textureSize: Vector2(16, 16),
          stepTime: 0.1,
        ),
      );

  /// Red corn
  static Future<SpriteAnimation> get redCorn => SpriteAnimation.load(
        'corn/red_corn.png',
        SpriteAnimationData.sequenced(
          amount: 5,
          textureSize: Vector2(16, 16),
          stepTime: 0.1,
        ),
      );
}
