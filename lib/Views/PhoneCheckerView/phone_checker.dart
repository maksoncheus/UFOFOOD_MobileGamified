import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:ufo_food/Model/product.dart';
import 'package:ufo_food/Views/ProfileView/my_profile.dart';
import 'package:ufo_food/data/auth.dart';
import 'package:ufo_food/data/size_config.dart';

import '../../data/constants.dart';
import '../../helper/product_data.dart';
import '../MainViews/Components/homepage.dart';

// ignore: must_be_immutable
class PhoneChecker extends StatefulWidget {
  PhoneChecker({super.key});
  static String routeName = '/phone';
  String phone = '';

  @override
  State<PhoneChecker> createState() => _PhoneCheckerState();
}

class _PhoneCheckerState extends State<PhoneChecker> {
  final maskFormatter = MaskTextInputFormatter(
      mask: '+# (###) ###-##-##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final TextEditingController _phoneController = TextEditingController();

  CheckNumber checkNumber = CheckNumber();
  List<CheckResponsePhoneNumber> number = [];

  CheckCode checkCode = CheckCode();
  List<CheckResponseCode> code = [];

  AuthService authService = AuthService();

  bool swap = false;

  final String defaultCode = '000000';

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Widget swapFormFirst = Column(
      children: [
        const Align(
            alignment: Alignment.centerLeft,
            child: AutoSizeText(
              "Введите номер телефона",
              maxLines: 1,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: kSecondaryColor),
            )),
        const SizedBox(
          height: 10,
        ),
        TextField(
          keyboardType: TextInputType.number,
          controller: _phoneController,
          decoration: InputDecoration(
              filled: true,
              fillColor: kFieldColor,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none)),
          inputFormatters: [maskFormatter],
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
            onPressed: () async {
              widget.phone = _phoneController.text;
              SharedPreferences sharedPreferences =
                  await SharedPreferences.getInstance();
              await checkCode.getCode(widget.phone);
              bool success = await checkNumber.getNumber(widget.phone);
              if (success) {
                setState(() {
                  swap = true;
                  number = checkNumber.datatosave;
                  code = checkCode.datatosave;
                  sharedPreferences.setString('phone', widget.phone);
                });
              } else {
                await checkNumber.createUser(widget.phone);
                await checkCode.getCode(widget.phone);
                bool isHere = await checkNumber.getNumber(widget.phone);
                if (isHere) {
                  setState(() {
                    swap = true;
                    number = checkNumber.datatosave;
                    code = checkCode.datatosave;
                    sharedPreferences.setString('phone', widget.phone);
                  });
                }
              }
            },
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6))),
                backgroundColor:
                    const MaterialStatePropertyAll(kSecondaryColor)),
            child: const Text(
              "Войти",
              style: TextStyle(color: Colors.white),
            ))
      ],
    );

    Widget swapFormSecond = Column(
      children: [
        const Align(
            alignment: Alignment.centerLeft,
            child: AutoSizeText(
              "Введите код подтверждения",
              maxLines: 1,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: kSecondaryColor),
            )),
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: _phoneController,
          decoration: InputDecoration(
              filled: true,
              fillColor: kFieldColor,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none)),
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          decoration: InputDecoration(
              filled: true,
              fillColor: kFieldColor,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none)),
          controller: TextEditingController(text: defaultCode),
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
            onPressed: () async {
              widget.phone = _phoneController.text;
              try {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Profile(phone: widget.phone)));
              } catch (ex) {
                Exception("Не удалось сравнить $ex");
              }
            },
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6))),
                backgroundColor:
                    const MaterialStatePropertyAll(kSecondaryColor)),
            child: const Text(
              "Отправить код",
              style: TextStyle(color: Colors.white),
            ))
      ],
    );
    return Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: AppBar(
          title: const AutoSizeText(
            "UFOFOOD",
            style:
                TextStyle(color: kSecondaryColor, fontWeight: FontWeight.w900),
          ),
          centerTitle: true,
        ),
        drawer: SideBarExample(controller: _controller),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                const Center(
                  child: AutoSizeText(
                    "Вход",
                    maxLines: 1,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                swap ? swapFormSecond : swapFormFirst,
              ],
            ),
          ),
        ));
  }
}

class CodeInputWidget extends StatefulWidget {
  const CodeInputWidget({super.key, required this.defaultCode});
  final String defaultCode;

  @override
  State<CodeInputWidget> createState() => _CodeInputWidgetState();
}

class _CodeInputWidgetState extends State<CodeInputWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: 'Введите код',
            ),
            controller: TextEditingController(text: widget.defaultCode),
          ),
          ElevatedButton(onPressed: () {}, child: const Text('Подтвердить')),
        ],
      ),
    );
  }
}
