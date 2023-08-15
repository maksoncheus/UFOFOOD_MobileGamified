import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:ufo_food/Views/ProductsByCategoryId/product_by_category_id.dart';
import 'package:ufo_food/Views/MainViews/Components/error_state.dart';
import 'package:ufo_food/helper/product_data.dart';
import '../../Model/category_product.dart';
import '../../data/constants.dart';
import '../MainViews/Components/loading_bar.dart';
import '../MainViews/Components/sidebar.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key});
  static String routeName = '/menu';

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  List<CategoryResponseProduct> products = [];
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
          style: TextStyle(color: kSecondaryColor, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
      ),
      drawer: SideBarExample(
        controller: _controller,
      ),
      body: Container(
        color: Colors.yellowAccent.shade100,
        child: Column(
          children: <Widget>[
            FutureBuilder(
              future: getProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const ErrorState();
                  } else {
                    return Expanded(
                        child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProductByCategoryIdView(
                                            product: products[index])));
                          },
                          child: categoryList(index),
                        );
                      },
                    ));
                  }
                } else {
                  return const LoadingWidget();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Container categoryList(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      width: 100,
      height: 70,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: kSecondaryColor),
      child: Center(child: Text(products[index].title)),
    );
  }
}
