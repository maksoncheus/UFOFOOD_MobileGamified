// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

import 'package:ufo_food/Model/product.dart';
import 'package:ufo_food/data/constants.dart';
import 'package:ufo_food/data/size_config.dart';

import '../MainViews/Components/homepage.dart';

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
              AutoSizeText(
                widget.product.title,
                style: const TextStyle(
                    color: kSecondaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.25),
                          blurRadius: 10,
                          spreadRadius: 5,
                          blurStyle: BlurStyle.inner)
                    ],
                    borderRadius: BorderRadius.circular(20),
                    color: kPrimaryColor),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topCenter,
                            height: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: const DecorationImage(
                                    image: AssetImage(
                                        "assets/images/ufoburger3.png"),
                                    fit: BoxFit.fill)),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Center(
                          child: AutoSizeText(
                            widget.product.description,
                            maxLines: 3,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16,
                                color: kTextColor,
                                fontWeight: FontWeight.normal),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ]),
              ),
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        const AutoSizeText(
                          "Вы можете добавить:",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(5),
                        ),
                        addIgredients("Капуста"),
                        addIgredients("Морковь"),
                        addIgredients("Укроп"),
                        addIgredients("Халапеньо"),
                        addIgredients("Котлета"),
                      ],
                    ),
                  ),
                ),
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

  Stack addIgredients(String name) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(20),
              vertical: getProportionateScreenHeight(5)),
          height: getProportionateScreenHeight(50),
          width: getProportionateScreenWidth(220),
          color: Colors.white,
          child: Row(
            children: <Widget>[
              const Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.remove_circle_outline,
                    size: 20,
                    color: kSecondaryColor,
                  ),
                ),
              ),
              Expanded(
                  child: Center(
                      child: AutoSizeText(
                name,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                wrapWords: false,
                maxLines: 1,
                minFontSize: 14,
                textAlign: TextAlign.center,
              ))),
              const Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.add_circle_outlined,
                    size: 20,
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
}
