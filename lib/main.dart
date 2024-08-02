import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:space_shooter_flame/overlay_screen.dart';

import 'space_shooter_game.dart';

void main() {
  runApp(GameWidget(
    game: SpaceShooterGame()..paused = true,
    overlayBuilderMap: {
      //welcome
      PlayState.welcome.name: (context, game) => const OverlayScreen(
            title: 'TAP TO PLAY',
            subtitle: 'Tap anywhere to continue.',
          ),
      // game paused
      PlayState.paused.name: (context, game) => const OverlayScreen(
        title: 'Game Paused',
        subtitle: 'Tap anywhere to continue.',
      ),
      //game over
      PlayState.gameOver.name: (context, game) => const OverlayScreen(
        title: 'Game Over',
        subtitle: 'Tap To restart the Game.',
      ),
    },
    initialActiveOverlays: [PlayState.welcome.name],
  ));
}
