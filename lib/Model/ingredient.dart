import 'package:get/get.dart';

class IngredientResponseProduct {
  int id;
  RxInt ingredientCounts = 0.obs;
  int categoryId;
  String title;

  IngredientResponseProduct({
    required this.id,
    required this.categoryId,
    required this.title,
  });

  void incrementCount() async {
    ingredientCounts.value++;
  }

  void decrementCount() async {
    ingredientCounts.value--;
  }
}

class SelectedIngredient {
  int id;
  String title;
  int count;

  SelectedIngredient(
    this.id,
    this.title,
    this.count,
  );

  Map<String, dynamic> toJson() => {"id": id, "title": title, "count": count};
}
