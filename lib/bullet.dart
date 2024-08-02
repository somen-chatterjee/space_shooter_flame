import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:space_shooter_flame/enemy.dart';
import 'package:space_shooter_flame/explosion.dart';
import 'package:space_shooter_flame/space_shooter_game.dart';

class Bullet extends SpriteAnimationComponent
    with HasGameRef<SpaceShooterGame>, CollisionCallbacks {
  Bullet({super.position})
      : super(
          size: Vector2(25, 50),
          anchor: Anchor.center,
        );

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      'bullet.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: .2,
        textureSize: Vector2(8, 16),
      ),
    );

    add(RectangleHitbox(
      collisionType: CollisionType.passive
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += dt * -500;

    if (position.y < -height) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if(other is Enemy){
      removeFromParent();
      other.removeFromParent();
      game.add(Explosion(position: position));
    }
  }
}
