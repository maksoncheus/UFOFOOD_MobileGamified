import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../data/constants.dart';

class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          SizedBox(
            height: 220,
          ),
          Icon(
            Icons.wifi_off_outlined,
            size: 100,
            color: Colors.red,
          ),
          SizedBox(
            height: 10,
          ),
          AutoSizeText(
            "Нет соединения",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: kTextColor),
          ),
          SizedBox(
            height: 10,
          ),
          AutoSizeText(
            "Проверьте соединение с сетью и обновите страницу",
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w400, color: kTextColor),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
