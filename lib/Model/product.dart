// ignore_for_file: public_member_api_docs, sort_constructors_first
class ResponseProduct {
  String title;
  String description;
  int price;
  String image;
  ResponseProduct({
    required this.title,
    required this.description,
    required this.price,
    required this.image,
  });

  // factory ResponseProduct.fromJson(dynamic json) {
  //   return ResponseProduct(
  //     title: json['title'] as String,
  //     description: json['description'] as String,
  //     price: json['price'] as int,
  //     image: json['image'] as String,
  //   );
  // }

  // static List<ResponseProduct> productFromSnap(List snap) {
  //   return snap.map((data) {
  //     return ResponseProduct.fromJson(data);
  //   }).toList();
  // }
}

class CategoryResponseProduct {
  int id;
  String title;

  CategoryResponseProduct({
    required this.id,
    required this.title,
  });
}
