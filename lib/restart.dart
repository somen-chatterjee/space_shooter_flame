import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:space_shooter_flame/enemy.dart';
import 'package:space_shooter_flame/game_over.dart';
import 'package:space_shooter_flame/player.dart';
import 'package:space_shooter_flame/space_shooter_game.dart';

import 'explosion.dart';

class Restart extends SpriteAnimationComponent
    with HasGameRef<SpaceShooterGame>, TapCallbacks {
  Restart()
      : super(
          size: Vector2(50, 50),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      'restart.png',
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: .2,
        textureSize: Vector2.all(128),
        // loop: false,
      ),
    );

    print("gameRef.size ${gameRef.size}");
    position = Vector2(gameRef.size.x / 2, gameRef.size.y / 1.5);

    add(RectangleHitbox());
  }

  @override
  void onTapUp(TapUpEvent event) {
    gameRef.resetGame();
  }
}
