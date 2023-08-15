import 'dart:math';

import 'package:flame/components.dart';
import 'package:ufo_food/Views/GameViews/Components/pipe.dart';

import '../main_game.dart';

class PipeGroup extends PositionComponent with HasGameRef<FlappyBurgerGame> {
  PipeGroup();

  final Random _random = Random();

  @override
  Future<void> onLoad() async {
    position.x = gameRef.size.x;
    final heightMinusGround = gameRef.size.y - 110;

    final spacing = 80 + _random.nextDouble() * (heightMinusGround / 4);
    final centerY =
        spacing + _random.nextDouble() * (heightMinusGround - spacing);
    addAll([
      Pipe(pipePosition: PipePosition.top, height: centerY - spacing / 1),
      Pipe(
          pipePosition: PipePosition.bottom,
          height: heightMinusGround - (centerY + spacing / 1))
    ]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= gameRef.speed * dt;
    if (position.x < -50) {
      removeFromParent();
    }
  }
}
