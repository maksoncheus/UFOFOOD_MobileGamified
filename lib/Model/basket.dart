import 'package:get/get.dart';

class BasketResponseProduct extends GetxController {
  int id;
  int userId;
  int menuId;
  int? price;
  var count = 1.obs;
  late String title;
  late String image;
  BasketResponseProduct({
    required this.id,
    required this.userId,
    required this.menuId,
    required this.price,
  });

  void incrementCount() {
    count.value++;
  }

  void decrementCount() {
    count.value--;
  }
}
