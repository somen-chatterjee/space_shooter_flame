import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/cupertino.dart';
import 'package:space_shooter_flame/enemy.dart';
import 'package:space_shooter_flame/explosion.dart';
import 'package:space_shooter_flame/game_over.dart';
import 'package:space_shooter_flame/player.dart';
import 'package:space_shooter_flame/restart.dart';

enum PlayState { welcome, paused, gameOver, won }

class SpaceShooterGame extends FlameGame
    with PanDetector, HasCollisionDetection, TapDetector {
  late Player player;
  bool isGameOver = false;

  // late PlayState _playState;
  // PlayState get playState => _playState;
  // set playState(PlayState playState) {
  //   _playState = playState;
  //   switch (playState) {
  //     case PlayState.welcome:
  //     case PlayState.gameOver:
  //     case PlayState.won:
  //       overlays.add(playState.name);
  //     case PlayState.playing:
  //       overlays.remove(PlayState.welcome.name);
  //       overlays.remove(PlayState.gameOver.name);
  //       overlays.remove(PlayState.won.name);
  //   }
  // }

  @override
  Future<void>? onLoad() async {
    final parallax = await loadParallaxComponent(
      [
        ParallaxImageData('stars_0.png'),
        ParallaxImageData('stars_1.png'),
        ParallaxImageData('stars_2.png'),
      ],
      baseVelocity: Vector2(0, -5),
      repeat: ImageRepeat.repeat,
      velocityMultiplierDelta: Vector2(0, 5),
    );

    add(parallax);
    player = Player();
    add(player);

    add(SpawnComponent(
      factory: (index) {
        return Enemy();
      },
      period: 1,
      area: Rectangle.fromLTWH(0, 0, size.x - 50, -Enemy.enemySize),
    ));
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    player.move(info.delta.global);
  }

  @override
  void onPanStart(DragStartInfo info) {
    player.startShooting();
  }

  @override
  void onPanEnd(DragEndInfo info) {
    player.stopShooting();
  }

  @override
  void onTapUp(TapUpInfo info) {
    print("onTap");
    if (!isGameOver) {
      if (overlays.isActive(PlayState.welcome.name)) {
        overlays.remove(PlayState.welcome.name);
        resumeEngine();
      } else if (overlays.isActive(PlayState.paused.name)) {
        overlays.remove(PlayState.paused.name);
        resumeEngine();
      } else {
        // if (!isGameOver) {
        overlays.add(PlayState.paused.name);
        // }
        pauseEngine();
      }
    } else {
      overlays.remove(PlayState.gameOver.name);
      resetGame();
    }
  }

  void resetGame() {
    // Remove all game components
    children.whereType<Enemy>().forEach((enemy) {
      enemy.removeFromParent();
    });
    children.whereType<Explosion>().forEach((explosion) {
      explosion.removeFromParent();
    });

    // Add a new player
    player = Player();
    add(player);

    // Remove the game over components
    children.whereType<Restart>().forEach((restart) {
      restart.removeFromParent();
    });
    children.whereType<GameOver>().forEach((gameOver) {
      gameOver.removeFromParent();
    });

    // Resume the game engine
    resumeEngine();

    isGameOver = false;
  }
}
