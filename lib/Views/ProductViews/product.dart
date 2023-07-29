import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Model/product.dart';
import '../../helper/product_data.dart';

class ViewProduct extends StatefulWidget {
  const ViewProduct({super.key, required this.product});
  final ResponseProduct product;

  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  List<IngredientResponseProduct> ingredients = [];

  getIngredient() async {
    IngredientProduct ingredientsdata = IngredientProduct();
    await ingredientsdata.getIngredient();
    ingredients = ingredientsdata.datatosave;
  }

  @override
  void initState() {
    super.initState();
    getIngredient();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getIngredient(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text("Ну e");
            } else {
              return ListView.builder(
                itemCount: ingredients.length,
                itemBuilder: (context, index) {
                  if (ingredients[index].categoryId ==
                      widget.product.categoryId) {
                    return ListTile(
                      title: Text(ingredients[index].title),
                      subtitle: Obx(() =>
                          Text(ingredients[index].ingredientCounts.toString())),
                      trailing: ElevatedButton(
                          onPressed: () {
                            ingredients[index].incrementCount();
                          },
                          child: Text("Нажми меня")),
                    );
                  }
                },
              );
            }
          } else {
            return Text("Пиздец");
          }
        },
      ),
    );
  }
}
