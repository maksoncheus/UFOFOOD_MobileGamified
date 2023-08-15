import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:ufo_food/Views/GameViews/main_game.dart';

class Pipe extends SpriteComponent with HasGameRef<FlappyBurgerGame> {
  Pipe({required PipePosition pipePosition, required double height})
      : _pipePosition = pipePosition,
        _height = height;

  final PipePosition _pipePosition;
  final double _height;

  @override
  Future<void> onLoad() async {
    final pipe = await Flame.images.load('pipe.png');
    final pipeBottom = await Flame.images.load('pipe_bottom.png');
    size = Vector2(50, _height);
    switch (_pipePosition) {
      case PipePosition.top:
        position.y = 0;
        sprite = Sprite(pipeBottom);
        break;
      case PipePosition.bottom:
        position.y = gameRef.size.y - size.y - 110;
        sprite = Sprite(pipe);
        break;
    }

    add(RectangleHitbox());
  }
}

enum PipePosition { top, bottom }
