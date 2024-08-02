import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:space_shooter_flame/space_shooter_game.dart';

class Enemy extends SpriteAnimationComponent with HasGameRef<SpaceShooterGame> {
  Enemy({super.position}) : super(size: Vector2.all(enemySize));

  static const enemySize = 50.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      'enemy.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.2,
        textureSize: Vector2.all(16),
      ),
    );
    
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += dt * 250;

    if(position.y > game.size.y){
      removeFromParent();
    }
  }
}
