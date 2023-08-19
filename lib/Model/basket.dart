// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:get/get.dart';

import 'ingredient.dart';

class BasketResponseProduct extends GetxController {
  int id;
  int userId;
  int menuId;
  int price;
  var count = 1.obs;
  late String title;
  late List<SelectedIngredient> ingredients;
  late String image;
  BasketResponseProduct({
    required this.id,
    required this.userId,
    required this.menuId,
    required this.price,
  });

  void incrementCount() {
    count.value++;
    price++;
  }

  void decrementCount() {
    count.value--;
    price--;
  }
}
