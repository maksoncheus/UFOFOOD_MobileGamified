import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:ufo_food/Views/GameViews/Components/background.dart';
import 'package:ufo_food/Views/GameViews/Components/burger.dart';
import 'package:ufo_food/Views/GameViews/Components/game_over.dart';
import 'package:ufo_food/Views/GameViews/Components/ground.dart';
import 'package:ufo_food/Views/GameViews/Components/pipe_group.dart';

class FlappyBurgerGame extends FlameGame
    with TapDetector, HasCollisionDetection {
  FlappyBurgerGame();

  late Burger _burger;

  double get speed => 400;
  double _timeSinceLastPipeGroup = 0;

  @override
  Future<void> onLoad() async {
    addAll([
      Background(),
      Ground(),
      _burger = Burger(),
      PipeGroup(),
    ]);
  }

  @override
  void onTap() {
    super.onTap();
    _burger.fly();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timeSinceLastPipeGroup += dt;
    if (_timeSinceLastPipeGroup > 2) {
      add(PipeGroup());
      _timeSinceLastPipeGroup = 0;
    }
  }

  void restart() {
    _timeSinceLastPipeGroup = 0;
    remove(_burger);
    removeAll([PipeGroup()]);
    addAll([
      Background(),
      Ground(),
      PipeGroup(),
      _burger = Burger(),
    ]);
    resumeEngine();
  }
}
