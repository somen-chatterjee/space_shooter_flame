import 'package:flame/components.dart';
import 'package:space_shooter_flame/restart.dart';
import 'package:space_shooter_flame/space_shooter_game.dart';

class GameOver extends SpriteComponent with HasGameRef<SpaceShooterGame> {
  GameOver()
      : super(
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await game.loadSprite('gameover.png');
    
    position = gameRef.size/2;

    gameRef.add(Restart());
  }
}
