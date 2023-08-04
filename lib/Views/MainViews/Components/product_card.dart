import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:ufo_food/Model/product.dart';

import '../../../data/constants.dart';
import '../../ProductViews/product_view.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({super.key, required this.product});
  final ResponseProduct product;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductView(
              product: widget.product,
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
                  widget.product.title,
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
                  widget.product.description,
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
                        "${widget.product.price} руб",
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
}
