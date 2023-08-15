import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:ufo_food/Views/GameViews/main_game.dart';

class Ground extends PositionComponent with HasGameRef<FlappyBurgerGame> {
  Ground();

  @override
  Future<void> onLoad() async {
    final image = await Flame.images.load('ground.png');
    size = Vector2(gameRef.size.x, 110);
    position = Vector2(0, gameRef.size.y - size.y);
    add(SpriteComponent(sprite: Sprite(image), size: size));
    add(RectangleHitbox());
  }
}
