import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:ufo_food/helper/product_data.dart';
import '../../Model/basket.dart';
import '../../data/constants.dart';
import '../MainViews/Components/error_state.dart';
import '../MainViews/Components/loading_bar.dart';
import '../MainViews/Components/sidebar.dart';

class BasketView extends StatefulWidget {
  const BasketView({super.key, required this.userId});
  final int? userId;

  @override
  State<BasketView> createState() => _BasketViewState();
}

class _BasketViewState extends State<BasketView> {
  final productRemovedStream =
      StreamController<BasketResponseProduct>.broadcast();

  List<BasketResponseProduct> addedProducts = [];

  getAddedProduct() async {
    Basket basket = Basket();
    await basket.getAddedProduct();
    addedProducts = basket.addedProduct;
  }

  @override
  void initState() {
    super.initState();
    getAddedProduct();
  }

  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const AutoSizeText(
            "UFOFOOD",
            style:
                TextStyle(color: kSecondaryColor, fontWeight: FontWeight.w900),
          ),
          centerTitle: true,
        ),
        drawer: SideBarExample(controller: _controller),
        body: Container(
          color: kPrimaryColor,
          child: Column(
            children: <Widget>[
              FutureBuilder(
                future: getAddedProduct(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const ErrorState();
                    } else {
                      return Expanded(
                          child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          const AutoSizeText(
                            "Корзина",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Expanded(child: basketListView(widget.userId)),
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6.0)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  const AutoSizeText(
                                    "К оплате: ",
                                    maxLines: 1,
                                  ),
                                  const Spacer(),
                                  ElevatedButton(
                                      onPressed: () async {
                                        Basket basket = Basket();
                                        try {
                                          for (var product in addedProducts) {
                                            await basket
                                                .getPurchaseStory(product);
                                          }
                                        } catch (error) {
                                          throw Exception(
                                              "Произошла ошибка при выполнении запроса $error");
                                        }
                                      },
                                      child: const Text("Нажми меня"))
                                ],
                              ),
                            ),
                          )
                        ],
                      ));
                    }
                  } else {
                    return const LoadingWidget();
                  }
                },
              )
            ],
          ),
        ));
  }

  ListView basketListView(int? userId) {
    return ListView.builder(
        itemCount: addedProducts.length,
        itemBuilder: (context, index) {
          if (addedProducts[index].userId == userId) {
            return SingleChildScrollView(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(6)),
                child: ListTile(
                    title: AutoSizeText(
                      addedProducts[index].title,
                      maxLines: 1,
                    ),
                    leading: const Image(
                        image: AssetImage("assets/images/ufoburger3.png")),
                    trailing: Wrap(
                      spacing: 12,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (addedProducts[index].count.value != 0) {
                              addedProducts[index].decrementCount();
                            }
                          },
                          child: GestureDetector(
                            onTap: () {
                              if (addedProducts[index].count > 1) {
                                addedProducts[index].decrementCount();
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                            "Удалить товар из корзины?"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Нет')),
                                          TextButton(
                                              onPressed: () async {
                                                Basket basket = Basket();
                                                await basket
                                                    .deleteProductFromBasket(
                                                  addedProducts[index],
                                                );
                                                Navigator.of(context).pop();
                                                setState(() {
                                                  addedProducts.removeAt(index);
                                                });
                                              },
                                              child: const Text('Да'))
                                        ],
                                      );
                                    });
                              }
                            },
                            child: const Icon(
                              Icons.remove_circle_outline,
                              size: 20,
                              color: kSecondaryColor,
                            ),
                          ),
                        ),
                        Obx(() => AutoSizeText(
                            addedProducts[index].count.value.toString())),
                        GestureDetector(
                          onTap: () {
                            addedProducts[index].incrementCount();
                          },
                          child: const Icon(
                            Icons.add_circle_outline,
                            size: 20,
                            color: kSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      "${addedProducts[index].price} р",
                      style: const TextStyle(color: kSecondaryColor),
                    )),
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
