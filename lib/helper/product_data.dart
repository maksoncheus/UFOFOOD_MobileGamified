import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
              categoryId: element['CategoryId'],
              id: element['id']);
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

class CheckCode {
  List<CheckResponseCode> datatosave = [];
  Future<void> getCode(String phoneNumber) async {
    var url = Uri.parse("http://89.108.77.131/api/user/code");
    try {
      final response = await post(url, body: {'Phone': phoneNumber});
      var jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        jsonData['response'].forEach((element) {
          CheckResponseCode code = CheckResponseCode(code: element['code']);
          datatosave.add(code);
        });
      }
      // ignore: avoid_print
      print(response.body);
    } catch (er) {
      Exception("Не удалось отправить запрос");
    }
  }
}

class CheckToken {
  Future<Map<String, dynamic>> authenticateUser(
      String phoneNumber, String code) async {
    var url = Uri.parse("http://89.108.77.131/api/user/auth");
    try {
      final response =
          await post(url, body: {'Phone': phoneNumber, 'Code': code});
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        var user = jsonData['response']['user'];
        var bearerTocken = jsonData['response']['bearerTocken'];
        var id = user['id'];
        return {
          'bearerTocken': bearerTocken,
          'id': id,
        };
      } else {
        throw Exception("Ошибка аутентификации: ${response.statusCode}");
      }
    } catch (error) {
      throw Exception("Не удалось отправить запрос: $error");
    }
  }
}

class UpdateInfo {
  Future<void> changeFirstName(String name) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var bearerTocken = sharedPreferences.getString('bearerTocken');
    var id = sharedPreferences.getInt('UserId').toString();
    if (bearerTocken != null) {
      var url = Uri.parse("http://89.108.77.131/api/user/update");
      try {
        final response = await post(url,
            body: {'Id': id, 'FirstName': name},
            headers: {'Authorization': 'Bearer $bearerTocken'});
        if (response.statusCode == 200) {
        } else {
          throw Exception("Ошибка при изменении имени: ${response.statusCode}");
        }
      } catch (error) {
        throw Exception("Не удалось отправить запрос: ${error}");
      }
    } else {
      throw Exception("Токен не найден");
    }
  }

  Future<void> changeLastName(String lastName) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var bearerTocken = sharedPreferences.getString('bearerTocken');
    var id = sharedPreferences.getInt('UserId').toString();
    if (bearerTocken != null) {
      var url = Uri.parse("http://89.108.77.131/api/user/update");
      try {
        final response = await post(url,
            body: {'Id': id, 'LastName': lastName},
            headers: {'Authorization': 'Bearer $bearerTocken'});
        if (response.statusCode == 200) {
        } else {
          throw Exception(
              "Ошибка при изменении фамилии: ${response.statusCode}");
        }
      } catch (error) {
        throw Exception("Не удалось отправить запрос: ${error}");
      }
    } else {
      throw Exception("Токен не найден");
    }
  }
}

class Basket {
  Future<void> addProduct(String product) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var bearerTocken = sharedPreferences.getString('bearerTocken');
    var userId = sharedPreferences.getInt('UserId').toString();
    var menuId = sharedPreferences.getInt('menuId').toString();
    var price = sharedPreferences.getInt('price').toString();
    var count = sharedPreferences.getInt('count').toString();
    if (bearerTocken != null) {
      var url = Uri.parse("http://89.108.77.131/api/basket/create");
      try {
        final response = await post(url, body: {
          'UserId': userId,
          'MenuId': menuId,
          'Price': price,
          'Count': count
        }, headers: {
          'Authorization': 'Bearer $bearerTocken'
        });
        if (response.statusCode == 200) {
        } else {
          throw Exception(
              "Ошибка при попытке добавить в корзину: ${response.statusCode}");
        }
      } catch (error) {
        throw Exception("Не удалось отправить запрос: ${error}");
      }
    } else {
      throw Exception("Токен не найден");
    }
  }
}
