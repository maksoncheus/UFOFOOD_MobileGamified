import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:ufo_food/Views/MainViews/main_view.dart';
import 'package:ufo_food/helper/product_data.dart';
import '../../Model/check_number.dart';
import '../../data/constants.dart';
import '../MainViews/Components/error_state.dart';
import '../MainViews/Components/loading_bar.dart';
import '../MainViews/Components/sidebar.dart';

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

  UpdateInfo updateInfo = UpdateInfo();

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
                                    firstNameField(),
                                    lastNameField(),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    logOutButton(context)
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

  ElevatedButton logOutButton(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          sharedPreferences.remove('phone');
          sharedPreferences.remove('isAuth');
          // ignore: use_build_context_synchronously
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MainView()));
        },
        child: const Text("Выйти"));
  }

  // SizedBox pushAlert() {
  //   return SizedBox(
  //     child: Container(
  //       width: double.infinity,
  //       height: 30,
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(6),
  //       ),
  //       child: const Padding(
  //         padding: EdgeInsets.only(left: 10),
  //         child: Align(
  //             alignment: Alignment.centerLeft,
  //             child: AutoSizeText(
  //               "Отправлять пуш уведомления",
  //               style: TextStyle(
  //                 fontSize: 14,
  //                 fontWeight: FontWeight.w500,
  //               ),
  //               maxLines: 1,
  //               wrapWords: false,
  //             )),
  //       ),
  //     ),
  //   );
  // }

  SizedBox lastNameField() {
    return SizedBox(
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
            onChanged: (value) {
              updateInfo.changeLastName(value);
            },
            decoration: InputDecoration(
                filled: true,
                fillColor: kFieldColor,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide.none)),
          ),
        ],
      ),
    );
  }

  SizedBox firstNameField() {
    return SizedBox(
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
            onChanged: (value) {
              updateInfo.changeFirstName(value);
            },
            decoration: InputDecoration(
                filled: true,
                fillColor: kFieldColor,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide.none)),
          ),
        ],
      ),
    );
  }
}
