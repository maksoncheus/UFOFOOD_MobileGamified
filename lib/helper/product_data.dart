import 'dart:convert';
import 'package:http/http.dart';
import 'package:ufo_food/Model/product.dart';

class Product {
  List<ResponseProduct> datatosave = [];

  Future<void> getProducts() async {
    var url = Uri.parse("http://89.108.77.131/api/menu");
    var response = await get(url);
    var jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      jsonData['response'].forEach((element) {
        int? price = int.tryParse(element['Price']);
        if (price != null) {
          ResponseProduct responseProduct = ResponseProduct(
              title: element['Title'],
              description: element['Description'],
              price: price,
              image: element['Image'],
              categoryId: element['CategoryId']);
          datatosave.add(responseProduct);
        }
      });
    }
  }
}

class CategoryProduct {
  List<CategoryResponseProduct> datatosave = [];

  Future<void> getCategory() async {
    var url = Uri.parse("http://89.108.77.131/api/menu/category");
    var response = await get(url);
    var jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      jsonData['response'].forEach((element) {
        CategoryResponseProduct responseProduct =
            CategoryResponseProduct(title: element['Title'], id: element['id']);
        datatosave.add(responseProduct);
      });
    }
  }
}

class IngredientProduct {
  List<IngredientResponseProduct> datatosave = [];

  Future<void> getIngredient() async {
    var url = Uri.parse("http://89.108.77.131/api/ingridient/all");
    var response = await get(url);
    var jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      jsonData['response'].forEach((element) {
        IngredientResponseProduct ingredientResponseProduct =
            IngredientResponseProduct(
                id: element['id'],
                categoryId: element['CategoryId'],
                title: element['Title']);
        datatosave.add(ingredientResponseProduct);
      });
    }
  }
}

class CheckPhone {
  List<CheckResponsePhone> datatosave = [];

  Future<bool> createPhone(String phone) async {
    Map<String, dynamic> request = {'Phone': phone};
    var url = Uri.parse("http://89.108.77.131/api/user/code");
    Map<String, String> headers = {"accept": "application/json"};
    var response = await post(url, body: request, headers: headers);
    var jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      String code = jsonData['response']['code'];
      if (code == 'ok') {
        return true;
      } else {
        return false;
      }
    } else {
      throw Exception("Не получилось загрузить");
    }
  }
}

class CheckNumber {
  List<CheckResponsePhoneNumber> datatosave = [];

  Future<bool> getNumber(String phoneNumber) async {
    var url =
        Uri.parse("http://89.108.77.131/api/user/show/by/phone/$phoneNumber");
    var response = await get(url);
    var jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (jsonData['response'].isNotEmpty) {
        jsonData['response'].forEach((element) {
          CheckResponsePhoneNumber checkResponsePhoneNumber =
              CheckResponsePhoneNumber(
                  id: element['id'],
                  phone: element['Phone'],
                  firstName: element['FirstName'].toString(),
                  lastName: element['LastName'].toString());
          datatosave.add(checkResponsePhoneNumber);
        });
        return true;
      } else {
        return false;
      }
    } else {
      throw Exception("Не удалось получить данные");
    }
  }

  Future<void> createUser(String phoneNumber) async {
    var url = Uri.parse("http://89.108.77.131/api/user/create");
    try {
      final response = await post(url, body: {'Phone': phoneNumber});
      // ignore: avoid_print
      print(response.body);
    } catch (er) {
      Exception("Не удалось создать юзера");
    }
  }
}
