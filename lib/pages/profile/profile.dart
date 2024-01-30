import 'package:book_store_mobile/basic/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var fullname = context.watch<UserInfoNotifier>().fullname;

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
          "Account",
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
          const SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Hi, $fullname",
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(
            height: 13,
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
          ListTile(
            leading: const Icon(
              Icons.person_outline,
              color: Colors.black,
            ),
            title: const Text(
              "My Profile",
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("/my_profile");
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
          ListTile(
            leading: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.black,
            ),
            title: const Text(
              "My Past Orders",
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("/past_orders");
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
          ListTile(
            leading: const Icon(
              Icons.logout_outlined,
              color: Colors.black,
            ),
            title: const Text(
              "Logout",
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              context.read<UserInfoNotifier>().logoutProcess();
              Navigator.of(context).pushReplacementNamed("/home");
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
