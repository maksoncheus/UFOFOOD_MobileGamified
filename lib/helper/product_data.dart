import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:ufo_food/Model/product.dart';

import '../Model/basket.dart';
import '../Model/category_product.dart';
import '../Model/check_number.dart';
import '../Model/ingredient.dart';
import '../Model/purchase_history.dart';

class Product {
  List<ResponseProduct> datatosave = [];

  Future<void> getProducts() async {
    var url = Uri.parse("http://89.108.77.131/api/menu");
    var request = await HttpClient().getUrl(url);
    var response = await request.close();
    var jsonData = jsonDecode(await utf8.decodeStream(response));

    if (response.statusCode == 200) {
      jsonData['response'].forEach((element) async {
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
    var request = await HttpClient().getUrl(url);
    var response = await request.close();
    var jsonData = jsonDecode(await utf8.decodeStream(response));

    if (response.statusCode == 200) {
      jsonData['response'].forEach((element) async {
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
    var request = await HttpClient().getUrl(url);
    var response = await request.close();
    var jsonData = jsonDecode(await utf8.decodeStream(response));
    if (response.statusCode == 200) {
      jsonData['response'].forEach((element) async {
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
    Map<String, dynamic> postRequest = {'Phone': phone};
    var url = Uri.parse("http://89.108.77.131/api/user/code");
    var jsonRequest = jsonEncode(postRequest);

    var httpClient = HttpClient();
    var request = await httpClient.postUrl(url);
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(jsonRequest));

    var response = await request.close();
    var responseBody = await utf8.decodeStream(response);

    var jsonData = jsonDecode(responseBody);

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
    var request = await HttpClient().getUrl(url);
    var response = await request.close();
    var jsonData = jsonDecode(await utf8.decodeStream(response));

    if (response.statusCode == 200) {
      if (jsonData['response'].isNotEmpty) {
        jsonData['response'].forEach((element) async {
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
      var httpClient = HttpClient();
      var request = await httpClient.postUrl(url);
      request.headers.set('content-type', 'application/json');
      var formData = {'Phone': phoneNumber};
      var jsonRequest = jsonEncode(formData);
      request.add(utf8.encode(jsonRequest));

      var response = await request.close();
      var responseBody = await utf8.decodeStream(response);
      // ignore: avoid_print
      print(responseBody);
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
      var httpClient = HttpClient();
      var request = await httpClient.getUrl(url);
      request.headers.set('content-type', 'application/json');

      var formData = {'Phone': phoneNumber};
      var jsonRequest = jsonEncode(formData);
      request.add(utf8.encode(jsonRequest));

      var response = await request.close();
      var responseBody = await utf8.decodeStream(response);

      var jsonData = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        jsonData['response'].forEach((element) async {
          CheckResponseCode code = CheckResponseCode(code: element['code']);
          datatosave.add(code);
        });
      }
      // ignore: avoid_print
      print(responseBody);
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
      var response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'Phone': phoneNumber, 'Code': code}));

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
        var httpClient = HttpClient();
        var request = await httpClient.postUrl(url);
        request.headers.set('content-type', 'application/json');
        request.headers.set('Authorization', 'Bearer $bearerTocken');

        var formData = {'Id': id, 'FirstName': name};
        var jsonRequest = json.encode(formData);
        request.add(utf8.encode(jsonRequest));

        var response = await request.close();

        if (response.statusCode == 200) {
        } else {
          throw Exception("Ошибка при изменении имени: ${response.statusCode}");
        }
      } catch (error) {
        throw Exception("Не удалось отправить запрос: $error");
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
        var httpClient = HttpClient();
        var request = await httpClient.postUrl(url);
        request.headers.set('content-type', 'application/json');
        request.headers.set('Authorization', 'Bearer $bearerTocken');

        var formData = {'Id': id, 'LastName': lastName};
        var jsonRequest = json.encode(formData);
        request.add(utf8.encode(jsonRequest));

        var response = await request.close();

        if (response.statusCode == 200) {
        } else {
          throw Exception(
              "Ошибка при изменении фамилии: ${response.statusCode}");
        }
      } catch (error) {
        throw Exception("Не удалось отправить запрос: $error");
      }
    } else {
      throw Exception("Токен не найден");
    }
  }
}

class Basket {
  List<BasketResponseProduct> addedProduct = [];

  Future<void> addIngridientToBasket(
      String ingridientCode, int ingridientId, int count) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var bearerTocken = sharedPreferences.getString('bearerTocken');

    if (bearerTocken != null) {
      var url = Uri.parse("http://89.108.77.131/api/basket/create");
      try {
        var httpClient = HttpClient();
        var request = await httpClient.postUrl(url);
        request.headers.set('content-type', 'application/json');
        request.headers.set('Authorization', 'Bearer $bearerTocken');

        var formData = {
          'IngridientCode': ingridientCode,
          'IngridientId': ingridientId,
          'Count': count
        };

        var jsonRequest = json.encode({'response': formData});
        request.add(utf8.encode(jsonRequest));
        var response = await request.close();
        if (response.statusCode == 200) {
        } else {
          throw Exception(
              "Ошбика при попытке добавить ингредиент в корзину: ${response.statusCode}");
        }
      } catch (error) {
        throw Exception("Не удалось отправить запрос: $error");
      }
    } else {
      throw Exception("Токен не найден");
    }
  }

  Future<void> addProduct(
      String? userId,
      String menuId,
      String price,
      String count,
      ResponseProduct product,
      List<SelectedIngredient> selectedIngredients) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var bearerTocken = sharedPreferences.getString('bearerTocken');

    if (bearerTocken != null) {
      var url = Uri.parse("http://89.108.77.131/api/basket/create");
      try {
        var httpClient = HttpClient();
        var request = await httpClient.postUrl(url);
        request.headers.set('content-type', 'application/json');
        request.headers.set('Authorization', 'Bearer $bearerTocken');

        List<Map<String, dynamic>> ingredientsValues = selectedIngredients
            .map((ingredient) => ingredient.toJson())
            .toList();

        var formData = {
          'UserId': userId,
          'MenuId': menuId,
          'Price': price,
          'Count': count,
          'Values': jsonEncode([
            {
              "Title": product.title,
              "Price": product.price,
              "Count": product.productCounts,
              "IngridientValue": ingredientsValues
            }
          ])
        };

        var jsonRequest = json.encode(formData);
        request.add(utf8.encode(jsonRequest));
        var response = await request.close();

        if (response.statusCode == 200) {
        } else {
          throw Exception(
              "Ошибка при попытке добавить в корзину: ${response.statusCode}");
        }
      } catch (error) {
        throw Exception("Не удалось отправить запрос: $error");
      }
    } else {
      throw Exception("Токен не найден");
    }
  }

  Future<void> getMenuInfo(BasketResponseProduct product) async {
    var url = Uri.parse("http://89.108.77.131/api/menu/show/${product.menuId}");
    try {
      var httpClient = HttpClient();
      var request = await httpClient.getUrl(url);
      request.headers.set('content-type', 'application/json');
      var response = await request.close();

      var jsonData = jsonDecode(await response.transform(utf8.decoder).join());
      if (response.statusCode == 200) {
        product.title = jsonData['response']['Title'];
        product.image = jsonData['response']['Image'];
      } else {
        throw Exception("Ошибка при выведении данных: ${response.statusCode}");
      }
    } catch (error) {
      throw Exception("Не удалось отправить запрос $error");
    }
  }

  Future<void> getAddedProduct() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var bearerTocken = sharedPreferences.getString('bearerTocken');

    if (bearerTocken != null) {
      var url = Uri.parse("http://89.108.77.131/api/basket/all");
      try {
        var httpClient = HttpClient();
        var request = await httpClient.getUrl(url);
        request.headers.set('content-type', 'application/json');
        request.headers.set('Authorization', 'Bearer $bearerTocken');

        var response = await request.close();

        var jsonData =
            jsonDecode(await response.transform(utf8.decoder).join());

        if (response.statusCode == 200) {
          for (var element in jsonData['response']) {
            int? price = int.tryParse(element['Price']);
            BasketResponseProduct products = BasketResponseProduct(
                id: element['id'],
                userId: element['UserId'],
                menuId: element['MenuId'],
                price: price);
            await getMenuInfo(products);
            addedProduct.add(products);
          }
        } else {
          throw Exception(
              "Ошибка при попытке вывести данные: ${response.statusCode}");
        }
      } catch (error) {
        throw Exception("Не удалось отправить запрос $error");
      }
    } else {
      throw Exception("Токен не найден");
    }
  }

  Future<void> getPurchaseStory(BasketResponseProduct product) async {
    var orderCode = 9993;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var bearerTocken = sharedPreferences.getString('bearerTocken');

    if (bearerTocken != null) {
      var url = Uri.parse("http://89.108.77.131/api/purchases/history/create");
      try {
        var httpClient = HttpClient();
        var request = await httpClient.postUrl(url);
        request.headers.set('content-type', 'application/json');
        request.headers.set('Authorization', 'Bearer $bearerTocken');

        var formData = {
          'UserId': product.userId.toString(),
          'OrderCode': orderCode.toString(),
          'Price': product.price.toString(),
          'Values': jsonEncode([
            {
              "Title": product.title.toString(),
              "Price": product.price.toString(),
              "Count": product.count.toString(),
            },
          ])
        };

        var jsonRequest = jsonEncode(formData);
        request.add(utf8.encode(jsonRequest));

        var response = await request.close();

        if (response.statusCode == 200) {
        } else {
          throw Exception("что-то не так ${response.statusCode}");
        }
      } catch (error) {
        throw Exception("Ошибка $error");
      }
    } else {
      throw Exception("Токен не найден");
    }
  }

  // Future<void> getPurchaseStory(BasketResponseProduct product) async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   var bearerTocken = sharedPreferences.getString('bearerTocken');

  //   if (bearerTocken != null) {
  //     var url = Uri.parse("http://89.108.77.131/api/purchases/history/create");
  //     try {
  //       var httpClient = HttpClient();
  //       var request = await httpClient.postUrl(url);
  //       request.headers.set('content-type', 'application/json');
  //       request.headers.set('Authorization', 'Bearer $bearerTocken');
  //       var formData = {
  //         'UserId': product.userId.toString(),
  //         'Price': product.price.toString(),
  //         'Values': jsonEncode([
  //           {
  //             "Title": product.title.toString(),
  //             "Price": product.price.toString(),
  //             "Count": product.count.toString(),
  //             "IngridientValue": {
  //               "Title": "Бургер с укропом",
  //               "Price": 200,
  //               "Count": 4,
  //               "IngridientValue": [
  //                 {
  //                   "Title": "Морковь",
  //                   "Count": 4,
  //                   "Title": "Жимолость",
  //                   "Count": 2
  //                 }
  //               ]
  //             }
  //           },
  //         ])
  //       };

  //       var jsonRequest = jsonEncode(formData);
  //       request.add(utf8.encode(jsonRequest));

  //       var response = await request.close();

  //       if (response.statusCode == 200) {
  //       } else {
  //         throw Exception("что-то не так ${response.statusCode}");
  //       }
  //     } catch (error) {
  //       throw Exception("Ошибка $error");
  //     }
  //   } else {
  //     throw Exception("Токен не найден");
  //   }
  // }

  Future<void> deleteProductFromBasket(BasketResponseProduct product) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var bearerTocken = sharedPreferences.getString('bearerTocken');

    if (bearerTocken != null) {
      var url =
          Uri.parse('http://89.108.77.131/api/basket/delete/${product.id}');
      try {
        var httpClient = HttpClient();
        var request = await httpClient.getUrl(url);
        request.headers.set('content-type', 'application/json');
        request.headers.set('Authorization', 'Bearer $bearerTocken');
        var response = await request.close();

        if (response.statusCode == 200) {
        } else {
          throw Exception("Не удалось удалить продукт: ${response.statusCode}");
        }
      } catch (error) {
        throw Exception("Подключиться по адресу не удалось: $error");
      }
    } else {
      throw Exception("Токен не найден");
    }
  }

  // Future<List<PurchaseHistoryResponse>> getAllPurchaseHistory(
  //     int? userId) async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   var bearerTocken = sharedPreferences.getString('bearerTocken');

  //   if (bearerTocken == null) {
  //     throw Exception('Токен не найден');
  //   }

  //   var url =
  //       Uri.parse('http://89.108.77.131/api/purchases/history/all/$userId');
  //   try {
  //     final client = HttpClient();
  //     final request = await client.getUrl(url);
  //     request.headers.set('content-type', 'application/json');
  //     request.headers.set('Authorization', 'Bearer $bearerTocken');
  //     final response = await request.close();

  //     if (response.statusCode == 200) {
  //       final jsonData = jsonDecode(
  //           await response.transform(utf8.decoder).join())['response'];

  //       final result = <PurchaseHistoryResponse>[];
  //       for (final elementList in jsonData) {
  //         for (final element in elementList) {
  //           final products = <PurchaseProduct>[];
  //           final values = jsonDecode(element['Values']);

  //           for (final value in values) {
  //             final ingredientsValues = <IngredientValue>[];
  //             final ingredientValueJson = value['IngridientValue'];

  //             if (ingredientValueJson != null) {
  //               ingredientValueJson.forEach((value) {
  //                 final ingredientValue = IngredientValue(
  //                     title: value['Title'], count: value['Count']);
  //                 ingredientsValues.add(ingredientValue);
  //               });
  //             }

  //             final product = PurchaseProduct(
  //                 title: value['Title'],
  //                 price: value['Price'],
  //                 count: value['Count'],
  //                 ingredientValues: ingredientsValues);
  //             products.add(product);
  //           }

  //           final response = PurchaseHistoryResponse(
  //               id: element['id'],
  //               userId: element['UserId'],
  //               products: products,
  //               orderCode: element['OrderCode'],
  //               createdAt: element['created_at']);
  //           result.add(response);
  //         }
  //       }
  //       return result;
  //     } else {
  //       throw Exception(
  //           "Не удалось вывести историю заказов: ${response.statusCode}");
  //     }
  //   } catch (error) {
  //     throw Exception('Не удалось подключиться по адресу: $error');
  //   }
  // }
}
