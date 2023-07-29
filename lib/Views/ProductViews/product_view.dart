// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidebarx/sidebarx.dart';

import 'package:ufo_food/Model/product.dart';
import 'package:ufo_food/data/constants.dart';
import 'package:ufo_food/data/size_config.dart';
import 'package:ufo_food/helper/product_data.dart';

import '../MainViews/Components/homepage.dart';
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
              Container(
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
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )),
                                  Expanded(
                                    child: ListView.builder(
                                        itemCount: ingredients.length,
                                        itemBuilder: (context, index) {
                                          if (ingredients[index].categoryId ==
                                              widget.product.categoryId) {
                                            return ingridientView(index);
                                          }
                                          return null;
                                        }),
                                  ),
                                ],
                              ),
                            );
                          }
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    )),
              ),
              TextButton(
                  onPressed: () {},
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(kSecondaryColor)),
                  child: const AutoSizeText(
                    "Добавить в корзину",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )),
              const SizedBox(
                height: 5,
              )
            ],
          ),
        ),
      ),
    );
  }

  Stack ingridientView(int index) {
    return Stack(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Row(
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: GestureDetector(
                  onTap: () {
                    if (ingredients[index].ingredientCounts != 0) {
                      ingredients[index].decrementCount();
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
                    AutoSizeText(ingredients[index].title),
                    Obx(() => AutoSizeText(
                        " x${ingredients[index].ingredientCounts}"))
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    ingredients[index].incrementCount();
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
