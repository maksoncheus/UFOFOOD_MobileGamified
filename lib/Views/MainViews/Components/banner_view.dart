import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../data/constants.dart';

class BannerView extends StatelessWidget {
  const BannerView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      height: 103,
      width: 268,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: kBannerColor,
      ),
      child: const Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 51, left: 10),
            child: SizedBox(
              height: 34,
              width: 192,
              child: AutoSizeText(
                "Два UFO бургера всего за 315 рублей",
                maxLines: 2,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 180, right: 40),
            child: Icon(
              Icons.sms_failed_rounded,
              size: 55,
              color: Colors.redAccent,
            ),
          )
        ],
      ),
    );
  }
}
