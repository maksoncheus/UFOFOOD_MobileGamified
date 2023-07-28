import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:ufo_food/Model/product.dart';
import 'package:ufo_food/Views/MainViews/main_view.dart';
import 'package:ufo_food/helper/product_data.dart';

import '../../data/constants.dart';
import '../MainViews/Components/homepage.dart';

class Profile extends StatefulWidget {
  const Profile({
    Key? key,
    required this.phone,
  }) : super(key: key);
  final String phone;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  List<CheckResponsePhoneNumber> number = [];

  String phoneNumber = '';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  getNumber() async {
    CheckNumber checkNumber = CheckNumber();
    await checkNumber.getNumber(widget.phone);
    number = checkNumber.datatosave;
  }

  @override
  void initState() {
    super.initState();
    getNumber();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(children: <Widget>[
        FutureBuilder(
            future: getNumber(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const ErrorState();
                } else {
                  return Expanded(
                      child: ListView.builder(
                          itemCount: number.length,
                          itemBuilder: (context, index) {
                            _nameController.text =
                                number[index].firstName.toString();
                            _lastNameController.text =
                                number[index].lastName.toString();
                            return SingleChildScrollView(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: Column(
                                  children: <Widget>[
                                    const Center(
                                        child: AutoSizeText(
                                      "Профиль",
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 100,
                                      child: Column(
                                        children: [
                                          const Align(
                                              alignment: Alignment.centerLeft,
                                              child: AutoSizeText(
                                                "Введите имя",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: kSecondaryColor),
                                                maxLines: 1,
                                              )),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextField(
                                            controller: _nameController,
                                            decoration: InputDecoration(
                                                filled: true,
                                                fillColor: kFieldColor,
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    borderSide:
                                                        BorderSide.none)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 100,
                                      child: Column(
                                        children: [
                                          const Align(
                                              alignment: Alignment.centerLeft,
                                              child: AutoSizeText(
                                                "Введите фамилию",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: kSecondaryColor),
                                                maxLines: 1,
                                              )),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextField(
                                            controller: _lastNameController,
                                            decoration: InputDecoration(
                                                filled: true,
                                                fillColor: kFieldColor,
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    borderSide:
                                                        BorderSide.none)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      child: Container(
                                        width: double.infinity,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: AutoSizeText(
                                                "Отправлять пуш уведомления",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                maxLines: 1,
                                                wrapWords: false,
                                              )),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ElevatedButton(
                                        onPressed: () async {
                                          SharedPreferences sharedPreferences =
                                              await SharedPreferences
                                                  .getInstance();
                                          sharedPreferences.remove('phone');
                                          // ignore: use_build_context_synchronously
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MainView()));
                                        },
                                        child: const Text("Выйти"))
                                  ],
                                ),
                              ),
                            );
                          }));
                }
              } else {
                return const LoadingWidget();
              }
            })
      ]),
    );
  }
}
