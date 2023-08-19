import 'dart:ui';

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
  late GameOver _over;

  double get speed => 400;
  double _timeSinceLastPipeGroup = 0;

  @override
  Future<void> onLoad() async {
    addAll([
      Background(),
      Ground(),
      _burger = Burger(),
      _over = GameOver(),
      PipeGroup(),
    ]);
    _over = GameOver();
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
    if (_timeSinceLastPipeGroup > 1.5) {
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

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (paused) {
      _over.render(canvas);
    }
  }
}
