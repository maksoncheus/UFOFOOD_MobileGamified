import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:ufo_food/Model/product.dart';
import 'package:ufo_food/Views/MainViews/Components/product_card.dart';
import 'package:ufo_food/data/constants.dart';
import 'package:ufo_food/helper/product_data.dart';
import '../Components/banner_view.dart';
import '../Components/error_state.dart';
import '../Components/loading_bar.dart';
import '../Components/sidebar.dart';
import '../Components/title_category.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ResponseProduct> products = [];
  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  String? finalPhone = '';

  Future getValidationPhone() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String? obtainedPhone = sharedPreferences.getString('phone');
    setState(() {
      finalPhone = obtainedPhone;
    });
  }

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
                    return const ErrorState();
                  } else {
                    return Expanded(
                      child: Column(
                        children: [
                          const BannerView(),
                          titleCategory("Каталог"),
                          Expanded(
                            child: ListView.builder(
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: <Widget>[
                                    ProductCard(
                                      product: products[index],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                } else {
                  return const LoadingWidget();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
