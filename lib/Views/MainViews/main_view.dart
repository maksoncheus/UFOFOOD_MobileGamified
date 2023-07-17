import 'package:flutter/material.dart';
import 'package:ufo_food/Views/MainViews/Components/homepage.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});
  static String routeName = '/main';

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}
