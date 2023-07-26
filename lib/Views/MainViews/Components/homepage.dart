import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:ufo_food/Model/product.dart';
import 'package:ufo_food/Views/MainViews/main_view.dart';
import 'package:ufo_food/Views/MenuViews/menu_view.dart';
import 'package:ufo_food/Views/PhoneCheckerView/phone_checker.dart';
import 'package:ufo_food/Views/ProductViews/product_view.dart';
import 'package:ufo_food/data/constants.dart';
import 'package:ufo_food/helper/product_data.dart';

import 'title_category.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ResponseProduct> products = [];
  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  getProducts() async {
    Product productsdata = Product();
    await productsdata.getProducts();
    products = productsdata.datatosave;
  }

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AutoSizeText(
          "UFOFOOD",
          style: TextStyle(color: kSecondaryColor, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
      ),
      drawer: SideBarExample(controller: _controller),
      body: Container(
        color: kPrimaryColor,
        child: Column(
          children: <Widget>[
            FutureBuilder(
              future: getProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
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
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: kTextColor),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          AutoSizeText(
                            "Проверьте соединение с сетью и обновите страницу",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: kTextColor),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: <Widget>[
                              bannerView(),
                              titleCategory("Каталог"),
                              productCard(context, index),
                            ],
                          );
                        },
                      ),
                    );
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector productCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductView(
              product: products[index],
            ),
          )),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        width: double.infinity,
        height: 241,
        decoration: BoxDecoration(boxShadow: const [
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              blurRadius: 10,
              spreadRadius: 5,
              blurStyle: BlurStyle.inner)
        ], borderRadius: BorderRadius.circular(6), color: kPrimaryColor),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
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
                padding: const EdgeInsets.only(left: 5, top: 5, bottom: 1),
                child: AutoSizeText(
                  products[index].title,
                  style: const TextStyle(
                      fontSize: 14,
                      color: kTextColor,
                      fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, top: 1),
                child: AutoSizeText(
                  products[index].description,
                  style: const TextStyle(
                      fontSize: 12,
                      color: kTextColor,
                      fontWeight: FontWeight.w400),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, top: 8, right: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: AutoSizeText(
                        "${products[index].price} руб",
                        style: const TextStyle(
                            fontSize: 12,
                            color: kSecondaryColor,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: Align(
                          alignment: Alignment.bottomRight,
                          child: SizedBox(
                            height: 25,
                            width: 140,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: kSecondaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6))),
                              onPressed: () {},
                              child: const Text(
                                "В КОРЗИНУ",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container bannerView() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      height: 103,
      width: 268,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: kBannerColor,
      ),
      child: const Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 51, left: 10),
            child: SizedBox(
              height: 34,
              width: 192,
              child: AutoSizeText(
                "Два UFO бургера всего за 315 рублей",
                maxLines: 2,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 210, right: 10),
            child: Icon(
              Icons.sms_failed_rounded,
              size: 55,
              color: Colors.redAccent,
            ),
          )
        ],
      ),
    );
  }
}

class SideBarExample extends StatelessWidget {
  const SideBarExample({Key? key, required SidebarXController controller})
      : _controller = controller,
        super(key: key);
  final SidebarXController _controller;

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      theme: const SidebarXTheme(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          iconTheme: IconThemeData(color: Colors.black),
          selectedTextStyle: TextStyle(color: Colors.black),
          selectedIconTheme: IconThemeData(color: Colors.black),
          selectedItemDecoration: BoxDecoration(color: kSecondaryColor)),
      extendedTheme: const SidebarXTheme(width: 250),
      headerBuilder: (context, extended) {
        return Column(
          children: <Widget>[
            Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                height: 150,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/logo.png")))),
          ],
        );
      },
      items: [
        SidebarXItem(
            icon: Icons.person_4_outlined,
            label: 'Профиль',
            onTap: () => Navigator.pushNamed(context, PhoneChecker.routeName)),
        SidebarXItem(
            icon: Icons.home_outlined,
            label: 'Главная',
            onTap: () => Navigator.pushNamed(context, MainView.routeName)),
        SidebarXItem(
            icon: Icons.category_outlined,
            label: 'Меню',
            onTap: () => Navigator.pushNamed(context, MenuView.routeName)),
        SidebarXItem(
            icon: Icons.shopping_basket_outlined,
            label: 'Корзина',
            onTap: () => null),
        SidebarXItem(
            icon: Icons.history_outlined,
            label: 'История заказов',
            onTap: () => null),
        SidebarXItem(
            icon: Icons.notifications_outlined,
            label: 'Уведомления',
            onTap: () => null),
        SidebarXItem(
            icon: Icons.settings_outlined,
            label: 'Настройки',
            onTap: () => null)
      ],
    );
  }
}
