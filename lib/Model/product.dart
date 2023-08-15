// ignore_for_file: public_member_api_docs, sort_constructors_first

class ResponseProduct {
  int id;
  var productCounts = 1;
  String title;
  int categoryId;
  String description;
  int? price;
  late int currentCategoryId;
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
