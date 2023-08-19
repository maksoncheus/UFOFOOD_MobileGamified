import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:ufo_food/Views/GameViews/main_game.dart';
import 'package:ufo_food/Views/PurchaseHistoryView/purchase_history.dart';

import '../../../data/constants.dart';
import '../../BasketViews/basket_view.dart';
import '../../MenuViews/menu_view.dart';
import '../../PhoneCheckerView/phone_checker.dart';
import '../../ProfileView/my_profile.dart';
import '../main_view.dart';

// ignore: must_be_immutable
class SideBarExample extends StatelessWidget {
  SideBarExample({Key? key, required SidebarXController controller})
      : _controller = controller,
        super(key: key);

  final SidebarXController _controller;
  String? phone;
  bool? isAuth;
  int? userId;

  Future<void> checkAuth() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    phone = sharedPreferences.getString('phone');
    isAuth = sharedPreferences.getBool('isAuth');
    userId = sharedPreferences.getInt('UserId');
  }

  @override
  Widget build(BuildContext context) {
    checkAuth();
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
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => phone != null
                        ? Profile(
                            phone: phone.toString(),
                          )
                        : PhoneChecker()))),
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
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => isAuth == true
                    ? BasketView(
                        userId: userId,
                      )
                    : PhoneChecker(),
              )),
        ),
        SidebarXItem(
          icon: Icons.history_outlined,
          label: 'История заказов',
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => isAuth == true
                    ? PurchaseHistoryView(
                        userId: userId,
                      )
                    : PhoneChecker(),
              )),
        ),
        SidebarXItem(
          icon: Icons.games,
          label: "Flappy Burger",
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => GameWidget(game: FlappyBurgerGame()))),
        )
      ],
    );
  }
}
