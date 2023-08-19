import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:ufo_food/Views/GameViews/main_game.dart';

class GameOver extends PositionComponent with HasGameRef<FlappyBurgerGame> {
  GameOver();

  // late double screenWidth;
  // late double screenHeight;

  // @override
  // Future<void> render(Canvas canvas) async {
  //   super.render(canvas);
  //   final image = await Flame.images.load('game_over_draw.png');
  //   canvas.translate(screenWidth / 2, screenHeight / 2);
  //   position = canvas.drawImage(
  //       image, Offset(-image.width / 2, -image.height / 2), Paint());
  // }

  // void onGamePaused() {
  // }

  // @override
  // Future<void> render(Canvas canvas) async {
  //   super.render(canvas);
  //   final image = await Flame.images.load('game_over_draw.png');
  //   size = Vector2(100, 100);
  //   position = Vector2(50, gameRef.size.y / 2 - size.y / 2);
  //   sprite = Sprite(image);
  // }

  // final containerRect = Rect.fromCenter(
  //       center: const Offset(100, 100), width: width, height: height);

  //   canvas.drawImageRect(
  //       image,
  //       Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
  //       containerRect,
  //       Paint());

  // @override
  // void render(Canvas canvas) {
  //   super.render(canvas);

  //   canvas.drawImageRect(
  //     image,
  //     Rect.fromLTWH(0, 0, width, height),
  //   );
  // }
}
