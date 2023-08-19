import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flutter/widgets.dart';
import 'package:ufo_food/Views/GameViews/Components/game_over.dart';
import 'package:ufo_food/Views/GameViews/main_game.dart';

class Burger extends SpriteComponent
    with HasGameRef<FlappyBurgerGame>, CollisionCallbacks {
  Burger();

  // late GameOver _gameOver;

  final velocity = 250; // скорость объекта

  @override
  Future<void> onLoad() async {
    final image = await Flame.images.load('ufoGameBurger.png');
    size = Vector2(80, 60);
    position = Vector2(50, gameRef.size.y / 2 - size.y - 2);
    sprite = Sprite(image);

    add(CircleHitbox());

    // _gameOver = GameOver();
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += velocity * dt; // обновление кадра его перемещения
  }

  // @override
  // void render(Canvas canvas) {
  //   super.render(canvas);
  //   if (gameRef.paused) {
  //     _gameOver.render(canvas);
  //   }
  // }

  void fly() {
    add(MoveByEffect(Vector2(0, -100),
        EffectController(duration: 0.2, curve: Curves.decelerate)));
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    gameRef.pauseEngine();
  }

  void gameOver() {
    gameRef.pauseEngine();
  }
}
