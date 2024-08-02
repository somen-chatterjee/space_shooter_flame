import 'package:flame/components.dart';
import 'package:space_shooter_flame/space_shooter_game.dart';

class Explosion extends SpriteAnimationComponent
    with HasGameRef<SpaceShooterGame> {

  Explosion({super.position}):
      super(
        size: Vector2.all(150),
        anchor: Anchor.center,
        removeOnFinish: true,
      );

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      'explosion.png',
      SpriteAnimationData.sequenced(
        amount: 6,
        stepTime: 0.1,
        textureSize: Vector2.all(32),
        loop: false,
      ),
    );
  }
}
