import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:ufo_food/Views/GameViews/main_game.dart';

class Background extends SpriteComponent with HasGameRef<FlappyBurgerGame> {
  Background();

  @override
  Future<void> onLoad() async {
    final image = await Flame.images.load('flappy_background.png');
    size = gameRef.size;
    sprite = Sprite(image);
  }
}
