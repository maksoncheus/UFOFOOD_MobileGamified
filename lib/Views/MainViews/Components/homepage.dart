import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:ufo_food/Model/product.dart';
import 'package:ufo_food/Views/MainViews/main_view.dart';
import 'package:ufo_food/Views/MenuViews/menu_view.dart';
import 'package:ufo_food/Views/ProductViews/product_view.dart';
import 'package:ufo_food/data/constants.dart';
import 'package:ufo_food/helper/product_data.dart';

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
                          return GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductView(product: products[index]),
                                )),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
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
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            image: const DecorationImage(
                                                image: AssetImage(
                                                    "assets/images/ufoburger3.png"),
                                                fit: BoxFit.fill)),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, top: 5, bottom: 1),
                                    child: AutoSizeText(
                                      products[index].title,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: kTextColor,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(left: 5, top: 1),
                                    child: AutoSizeText(
                                      products[index].description,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: kTextColor,
                                          fontWeight: FontWeight.normal),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, top: 1, right: 5),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: AutoSizeText(
                                            "${products[index].price} руб",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: kSecondaryColor,
                                                fontWeight: FontWeight.normal),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: TextButton(
                                                style: const ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStatePropertyAll<
                                                              Color>(
                                                          kSecondaryColor),
                                                ),
                                                onPressed: () {},
                                                child: const AutoSizeText(
                                                  "Купить",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
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
}

// class ProductTemplate extends StatelessWidget {
//   String title, description;
//   ProductTemplate({super.key, required this.title, required this.description});

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         margin:
//             EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
//         width: double.infinity,
//         height: getProportionateScreenHeight(250),
//         decoration: BoxDecoration(
//           boxShadow: const [
//             BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.25), blurRadius: 50)
//           ],
//           borderRadius: BorderRadius.circular(20),
//           color: kPrimaryColor,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               children: <Widget>[
//                 Container(
//                   alignment: Alignment.topCenter,
//                   height: getProportionateScreenHeight(140),
//                   color: Colors.amber,
//                 ),
//                 SizedBox(
//                   height: getProportionateScreenHeight(8),
//                 ),
//                 Padding(
//                   padding:
//                       EdgeInsets.only(left: getProportionateScreenWidth(10)),
//                   child: Text(
//                     title,
//                     style: const TextStyle(fontSize: 18, color: kTextColor),
//                   ),
//                 ),
//                 SizedBox(
//                   height: getProportionateScreenHeight(2),
//                 ),
//                 Padding(
//                   padding:
//                       EdgeInsets.only(left: getProportionateScreenWidth(10)),
//                   child: Text(
//                     description,
//                     style: const TextStyle(fontSize: 14, color: kTextColor),
//                   ),
//                 )
//               ],
//             )
//           ],
//         ),
//       ),
//     );
// return Column(
//   children: <Widget>[
//     SizedBox(
//       height: getProportionateScreenHeight(10),
//     ),
//     Text(
//       title,
//       style: const TextStyle(fontSize: 18, color: Colors.amber),
//     ),
//     SizedBox(
//       height: getProportionateScreenHeight(10),
//     ),
//     Text(
//       description,
//       style: const TextStyle(fontSize: 14, color: kTextColor),
//     )
//   ],
// );

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
      footerDivider: Divider(
        color: Colors.black.withOpacity(0.6),
      ),
      headerBuilder: (context, extended) {
        return const SizedBox(
            height: 150,
            child: Image(image: AssetImage("assets/images/logo.png")));
      },
      items: [
        SidebarXItem(
            icon: Icons.person_4_outlined, label: 'Профиль', onTap: () => null),
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
