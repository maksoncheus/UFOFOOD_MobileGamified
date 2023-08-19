class PurchaseProduct {
  String title;
  String price;
  String count;
  List<IngredientValue> ingredientValues;
  PurchaseProduct({
    required this.title,
    required this.price,
    required this.count,
    required this.ingredientValues,
  });
}

class PurchaseHistoryResponse {
  int id;
  int userId;
  List<PurchaseProduct> products;
  String status;
  String createdAt;
  PurchaseHistoryResponse({
    required this.id,
    required this.userId,
    required this.products,
    required this.status,
    required this.createdAt,
  });
}

class IngredientValue {
  String title;
  int? count;
  IngredientValue({
    required this.title,
    required this.count,
  });
}
