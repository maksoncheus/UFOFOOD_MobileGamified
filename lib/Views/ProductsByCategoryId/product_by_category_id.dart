import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:ufo_food/Model/product.dart';
import 'package:ufo_food/Views/MainViews/Components/product_card.dart';
import 'package:ufo_food/helper/product_data.dart';
import '../MainViews/Components/error_state.dart';
import '../MainViews/Components/loading_bar.dart';
import '../MainViews/Components/sidebar.dart';
import '../../data/constants.dart';

class ProductByCategoryIdView extends StatefulWidget {
  const ProductByCategoryIdView({super.key, required this.product});
  final CategoryResponseProduct product;

  @override
  State<ProductByCategoryIdView> createState() =>
      _ProductByCategoryIdViewState();
}

class _ProductByCategoryIdViewState extends State<ProductByCategoryIdView> {
  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  List<ResponseProduct> products = [];

  getProducts() async {
    Product product = Product();
    await product.getProducts();
    products = product.datatosave;
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
        drawer: SideBarExample(controller: _controller),
        body: FutureBuilder(
          future: getProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const ErrorState();
              } else {
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    if (widget.product.id == products[index].categoryId) {
                      return Column(
                        children: [ProductCard(product: products[index])],
                      );
                    } else {
                      return Container();
                    }
                  },
                );
              }
            } else {
              return const LoadingWidget();
            }
          },
        ));
  }
}
