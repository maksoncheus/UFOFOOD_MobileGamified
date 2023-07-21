import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:ufo_food/data/size_config.dart';

import '../../data/constants.dart';
import '../MainViews/Components/homepage.dart';

class PhoneChecker extends StatefulWidget {
  const PhoneChecker({super.key});
  static String routeName = '/phone';

  @override
  State<PhoneChecker> createState() => _PhoneCheckerState();
}

class _PhoneCheckerState extends State<PhoneChecker> {
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
      drawer: SideBarExample(controller: _controller),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: Stack(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: AutoSizeText(
                          "Вход по номеру",
                          maxLines: 1,
                        )),
                  ),
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 40, left: 30, right: 30),
                        child: AutoSizeText(
                          "Введите номер телефона",
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 18,
                              color: kSecondaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, right: 30, top: 5),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: const TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: kSecondaryColor),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)))),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, right: 30, top: 10),
                        child: TextButton(
                            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(
                                  kSecondaryColor),
                            ),
                            onPressed: () {},
                            child: const AutoSizeText(
                              "Отправить код",
                              maxLines: 1,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
