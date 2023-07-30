import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

import '../../Model/product.dart';
import '../../data/constants.dart';
import '../MainViews/Components/homepage.dart';

class BasketView extends StatefulWidget {
  const BasketView({super.key, required this.product});
  final ResponseProduct product;

  @override
  State<BasketView> createState() => _BasketViewState();
}

class _BasketViewState extends State<BasketView> {
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
        body: const Column());
  }
}
