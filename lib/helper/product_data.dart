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
          );
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
