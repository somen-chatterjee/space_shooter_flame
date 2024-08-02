import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:space_shooter_flame/bullet.dart';
import 'package:space_shooter_flame/enemy.dart';
import 'package:space_shooter_flame/explosion.dart';
import 'package:space_shooter_flame/game_over.dart';
import 'package:space_shooter_flame/space_shooter_game.dart';

class Player extends SpriteAnimationComponent
    with HasGameRef<SpaceShooterGame>, CollisionCallbacks{
  late final SpawnComponent _bulletSpawner;

  Player()
      : super(
          size: Vector2(100, 150),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      'player.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: .2,
        textureSize: Vector2(32, 48),
      ),
    );

    position = Vector2(gameRef.size.x / 2, gameRef.size.y - 200);

    _bulletSpawner = SpawnComponent(
      period: .2,
      selfPositioning: true,
      factory: (index) {
        return Bullet(
          position: position + Vector2(0, -height / 2),
        );
      },
      autoStart: false,
    );
    game.add(_bulletSpawner);
    add(RectangleHitbox(
      collisionType: CollisionType.active
    ));
  }

  void move(Vector2 delta) {
    print("delta ${delta}");
    position.add(delta);
  }

  void startShooting() {
    _bulletSpawner.timer.start();
  }

  void stopShooting() {
    _bulletSpawner.timer.stop();
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if(other is Enemy){
      removeFromParent();
      other.removeFromParent();
      gameRef.add(Explosion(position: position));
      // gameRef.add(GameOver());
      gameRef.overlays.add(PlayState.gameOver.name);

      gameRef.isGameOver = true;

      Future.delayed(const Duration(milliseconds: 650),(){
        gameRef.pauseEngine();
      });
    }
  }
}
