import 'package:book_store_mobile/basic/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var superuser = context.watch<UserInfoNotifier>().superuser;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed("/home");
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: const Text(
          "More",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        titleTextStyle: const TextStyle(color: Colors.black),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          Visibility(
            visible: superuser,
            child: ListTile(
              leading: const Icon(
                Icons.book_outlined,
                color: Colors.black,
              ),
              title: const Text(
                "Create New Book",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed("/create_book");
              },
            ),
          ),
          Visibility(
            visible: superuser,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ),
          Visibility(
            visible: superuser,
            child: ListTile(
              leading: const Icon(
                Icons.list_alt_outlined,
                color: Colors.black,
              ),
              title: const Text(
                "Books List",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed("/book_list");
              },
            ),
          ),
          Visibility(
            visible: superuser,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ),
          Visibility(
            visible: superuser,
            child: ListTile(
              leading: const Icon(
                Icons.person_2_outlined,
                color: Colors.black,
              ),
              title: const Text(
                "Users List",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed("/user_list");
              },
            ),
          ),
          Visibility(
            visible: superuser,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.settings_outlined,
              color: Colors.black,
            ),
            title: const Text(
              "Settings",
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("/setting");
            },
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
