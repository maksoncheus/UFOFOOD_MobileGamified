import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:ufo_food/Views/MainViews/Components/homepage.dart';
import 'package:ufo_food/helper/product_data.dart';

import '../../Model/product.dart';
import '../../data/constants.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key});
  static String routeName = '/menu';

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  List<CategoryResponseProduct> products = [];
  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  getProducts() async {
    CategoryProduct productsdata = CategoryProduct();
    await productsdata.getCategory();
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
          style:
              TextStyle(color: kSecondaryColor, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
      ),
      drawer: SideBarExample(
        controller: _controller,
      ),
      body: Container(
        color: kPrimaryColor,
        child: Column(
          children: <Widget>[
            FutureBuilder(
              future: getProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Text('Ошибка при загрузке продуктов');
                  } else {
                    return Expanded(
                        child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          width: double.infinity,
                          height: 200,
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
                          child: Center(child: Text(products[index].title)),
                        );
                      },
                    ));
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
