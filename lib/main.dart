import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ufo_food/Views/MainViews/main_view.dart';
import 'package:ufo_food/data/constants.dart';
import 'package:ufo_food/data/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UFO FOOD',
      theme: ThemeData(
          fontFamily: "Mulish",
          textTheme: const TextTheme(
              bodyLarge: TextStyle(color: kTextColor),
              bodyMedium: TextStyle(color: kTextColor)),
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      initialRoute: MainView.routeName,
      routes: routes,
    );
  }
}
