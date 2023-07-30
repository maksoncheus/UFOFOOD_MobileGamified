// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:get/get.dart';

class ResponseProduct extends GetxController {
  int id;
  var productCounts = 0.obs;
  String title;
  int categoryId;
  String description;
  int price;
  String image;
  ResponseProduct({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.description,
    required this.price,
    required this.image,
  });
}

class CategoryResponseProduct {
  int id;
  String title;

  CategoryResponseProduct({
    required this.id,
    required this.title,
  });
}

class IngredientResponseProduct extends GetxController {
  int id;
  var ingredientCounts = 0.obs;
  int categoryId;
  String title;

  IngredientResponseProduct({
    required this.id,
    required this.categoryId,
    required this.title,
  });

  void incrementCount() {
    ingredientCounts.value++;
  }

  void decrementCount() {
    ingredientCounts.value--;
  }
}

class CheckResponsePhone {
  String code;
  CheckResponsePhone({
    required this.code,
  });

  factory CheckResponsePhone.fromJson(Map<String, dynamic> json) =>
      CheckResponsePhone(code: json['code']);
}

class CheckResponsePhoneNumber {
  int id;
  String firstName;
  String lastName;
  String phone;
  CheckResponsePhoneNumber({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
  });
}

class CheckResponseCode {
  String code;
  CheckResponseCode({
    required this.code,
  });
}
