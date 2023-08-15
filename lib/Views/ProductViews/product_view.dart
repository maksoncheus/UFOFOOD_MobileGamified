// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:ufo_food/Model/product.dart';
import 'package:ufo_food/Views/BasketViews/basket_view.dart';
import 'package:ufo_food/data/constants.dart';
import 'package:ufo_food/data/size_config.dart';
import 'package:ufo_food/helper/product_data.dart';
import '../../Model/ingredient.dart';
import '../MainViews/Components/loading_bar.dart';
import '../MainViews/Components/sidebar.dart';
import '../MainViews/Components/title_category.dart';

class ProductView extends StatefulWidget {
  const ProductView({
    Key? key,
    required this.product,
  }) : super(key: key);
  final ResponseProduct product;
  static String routeName = '/product';

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  List<IngredientResponseProduct> ingredients = [];
  List<SelectedIngredient> selectedIngredients = [];

  void __updateIngredientValue(
      IngredientResponseProduct ingredient, int count) {
    var found = false;
    for (var i = 0; i < ingredients.length; i++) {
      if (ingredients[i].title == ingredient.title) {
        ingredients[i].ingredientCounts.value = count;
        found = true;
        break;
      }
    }
    if (!found) {
      throw Exception("Такого ингредиента нет");
    }

    final selectedItem = selectedIngredients
        .firstWhereOrNull((item) => item.title == ingredient.title);
    if (selectedItem != null) {
      selectedItem.count = count;
    }
  }

  Basket basket = Basket();

  getIngredient() async {
    IngredientProduct ingredientsdata = IngredientProduct();
    await ingredientsdata.getIngredient();
    ingredients = ingredientsdata.datatosave;
  }

  @override
  void initState() {
    super.initState();
    getIngredient();
    selectedIngredients = [];
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        title: const AutoSizeText(
          "UFOFOOD",
          style: TextStyle(color: kSecondaryColor, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
      ),
      drawer: SideBarExample(
        controller: _controller,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              titleCategory(widget.product.title),
              imageView(),
              ingredientView(),
              addToBasket(context),
              const SizedBox(
                height: 5,
              )
            ],
          ),
        ),
      ),
    );
  }

  TextButton addToBasket(BuildContext context) {
    return TextButton(
        onPressed: () async {
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          var isAuth = sharedPreferences.getBool('isAuth');
          int? userId = sharedPreferences.getInt('UserId');
          if (isAuth == true) {
            await basket.addProduct(
                userId.toString(),
                widget.product.id.toString(),
                widget.product.price.toString(),
                1.toString(),
                widget.product,
                selectedIngredients);

            // ignore: use_build_context_synchronously
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BasketView(
                          userId: userId,
                        )));
          }
        },
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(kSecondaryColor)),
        child: const AutoSizeText(
          "Добавить в корзину",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ));
  }

  Container ingredientView() {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
          vertical: getProportionateScreenHeight(20)),
      width: double.infinity,
      height: getProportionateScreenHeight(360),
      color: Colors.white,
      child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: getProportionateScreenHeight(10),
              horizontal: getProportionateScreenWidth(50)),
          child: FutureBuilder(
            future: getIngredient(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return errorToConnect();
                } else {
                  return Container(
                    height: 249,
                    width: 312,
                    color: Colors.white,
                    child: Column(
                      children: [
                        const Center(
                            child: AutoSizeText(
                          "Вы можете добавить:",
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                        Expanded(
                          child: ListView.builder(
                              itemCount: ingredients.length,
                              itemBuilder: (context, index) {
                                if (ingredients[index].categoryId ==
                                    widget.product.categoryId) {
                                  return ingridientView(index);
                                }
                                return Container();
                              }),
                        ),
                      ],
                    ),
                  );
                }
              } else {
                return const LoadingWidget();
              }
            },
          )),
    );
  }

  Stack ingridientView(int index) {
    return Stack(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Row(
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: GestureDetector(
                  onTap: () async {
                    // ignore: unrelated_type_equality_checks
                    // if (ingredients[index].ingredientCounts != 0) {
                    //   ingredients[index].decrementCount();
                    // }
                    final selectedItem = selectedIngredients.firstWhereOrNull(
                        (item) => item.title == ingredients[index].title);
                    if (selectedItem != null) {
                      ingredients[index].decrementCount();
                      selectedItem.count--;
                      if (selectedItem.count == 0) {
                        selectedIngredients.remove(selectedItem);
                      }
                    }
                    for (final selectedItem in selectedIngredients) {
                      final ingredient = ingredients.firstWhere(
                          (element) => element.title == selectedItem.title);
                      ingredient.ingredientCounts.value = selectedItem.count;
                    }
                  },
                  child: const Icon(
                    Icons.remove_circle_outline,
                    size: 30,
                    color: kSecondaryColor,
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: AutoSizeText(
                      ingredients[index].title,
                      maxLines: 1,
                    )),
                    Obx(() => AutoSizeText(
                        " x${ingredients[index].ingredientCounts}"))
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () async {
                    // ingredients[index].incrementCount();
                    final selectedItem = selectedIngredients.firstWhereOrNull(
                        (item) => item.title == ingredients[index].title);
                    if (selectedItem != null) {
                      ingredients[index].incrementCount();
                      selectedItem.count++;
                    } else {
                      selectedIngredients.add(SelectedIngredient(
                          ingredients[index].id,
                          ingredients[index].title,
                          ingredients[index].ingredientCounts.value));
                    }
                    for (final selectedItem in selectedIngredients) {
                      final ingredient = ingredients.firstWhere(
                          (element) => element.title == selectedItem.title);
                      ingredient.ingredientCounts.value = selectedItem.count;
                    }
                  },
                  child: const Icon(
                    Icons.add_circle_outline,
                    size: 30,
                    color: kSecondaryColor,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Center errorToConnect() {
    return const Center(
      child: Column(
        children: [
          SizedBox(
            height: 220,
          ),
          Icon(
            Icons.wifi_off_outlined,
            size: 100,
            color: Colors.red,
          ),
          SizedBox(
            height: 10,
          ),
          AutoSizeText(
            "Нет соединения",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: kTextColor),
          ),
          SizedBox(
            height: 10,
          ),
          AutoSizeText(
            "Проверьте соединение с сетью и обновите страницу",
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w400, color: kTextColor),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Column imageView() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                alignment: Alignment.topCenter,
                height: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    image: const DecorationImage(
                        image: AssetImage("assets/images/ufoburger3.png"),
                        fit: BoxFit.fill)),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: AutoSizeText(
              widget.product.description,
              maxLines: 3,
              style: const TextStyle(
                  fontSize: 12, color: kTextColor, fontWeight: FontWeight.w400),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ]);
  }
}
