import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:ufo_food/Views/GameViews/main_game.dart';
import 'package:ufo_food/data/constants.dart';

class GameOver extends SpriteComponent with HasGameRef<FlappyBurgerGame> {
  GameOver();

  // final containerRect = Rect.fromCenter(
  //       center: const Offset(100, 100), width: width, height: height);

  //   canvas.drawImageRect(
  //       image,
  //       Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
  //       containerRect,
  //       Paint());

  @override
  Future<void> onLoad() async {
    final image = await Flame.images.load('game_over.png');
    size = Vector2(80, 60);
    position = Vector2(50, gameRef.size.y / 2 - size.y - 2);
    sprite = Sprite(image);
  }

  // @override
  // void render(Canvas canvas) {
  //   super.render(canvas);

  //   canvas.drawImageRect(
  //     image,
  //     Rect.fromLTWH(0, 0, width, height),
  //   );
  // }
}
