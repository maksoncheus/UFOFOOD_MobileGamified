// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:ufo_food/Model/product.dart';

import '../../data/constants.dart';
import '../MainViews/Components/homepage.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({
    Key? key,
    required this.phone,
  }) : super(key: key);
  final CheckResponsePhoneNumber phone;

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.phone.firstName;
    _lastNameController.text = widget.phone.lastName;
    _phoneController.text = widget.phone.phone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AutoSizeText(
          "UFOFOOD",
          style: TextStyle(color: kSecondaryColor, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
      ),
      drawer: SideBarExample(controller: _controller),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              titleText("Профиль"),
              const SizedBox(
                height: 10,
              ),
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
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide.none)),
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
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide.none)),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              titleText("Сменить номер"),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                height: 100,
                child: Column(
                  children: [
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: AutoSizeText(
                          "Введите номер телефона",
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
                      controller: _phoneController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: kFieldColor,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide.none)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Center titleText(String text) {
    return Center(
      child: AutoSizeText(
        text,
        maxLines: 1,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
