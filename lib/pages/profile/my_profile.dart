import 'package:book_store_mobile/api/user_api.dart';
import 'package:book_store_mobile/basic/providers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  String email = "", fullname = "", datejoined = "", lastLogin = "";
  String profile = "";
  bool superuser = false;
  bool hasData = false;

  String error_ = "";
  bool hasError = false;

  String dateJoinedDate = "";
  String lastLoginDate = "";

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();

  void changeTimeFunction(String dateJoind, String lastLogin) {
    try {
      datejoined = datejoined.trim().replaceAll(RegExp(r'[^\d]'), '');
      if (dateJoind.isNotEmpty && lastLogin.isNotEmpty) {
        DateTime dateJoinedDatetime =
            DateTime.fromMillisecondsSinceEpoch(int.parse(dateJoind) * 1000);
        dateJoinedDate =
            DateFormat('yyyy-MM-dd & HH:mm').format(dateJoinedDatetime);

        DateTime lastLoginDatetime =
            DateTime.fromMillisecondsSinceEpoch(int.parse(lastLogin) * 1000);
        lastLoginDate =
            DateFormat('yyyy-MM-dd & HH:mm').format(lastLoginDatetime);
      } else {
        // ignore: avoid_print
        print('datejoined and last_login string is empty or null');
      }
    } catch (e) {
      dateJoinedDate = "";
      lastLoginDate = "";
      // ignore: avoid_print
      print('Failed to parse datejoined string: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    int id = context.read<UserInfoNotifier>().userid;
    String accessToken = context.read<UserInfoNotifier>().accesstoken;
    retrieveAccount(id, accessToken).then((value) {
      email = value["data"]["email"];
      fullname = value["data"]["fullname"];
      datejoined = value["data"]["date_joined"];
      lastLogin = value["data"]["last_login"];
      profile = value["data"]["profile"] ?? "";
      superuser = value["data"]["is_superuser"];
      changeTimeFunction(datejoined, lastLogin);
      if (value["success"]) {
        setState(() {
          hasData = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _emailController.text = email;
    _fullnameController.text = fullname;
    int id = context.read<UserInfoNotifier>().userid;
    String access = context.read<UserInfoNotifier>().accesstoken;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed("/profile");
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: const Text(
          "My Profile",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        titleTextStyle: const TextStyle(color: Colors.black),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: !hasData
          ? const Center(
              child: Text(
                "There is a problem to load data.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    CircleAvatar(
                      backgroundImage: profile.isNotEmpty
                          ? CachedNetworkImageProvider(profile)
                          : const AssetImage("images/person.png")
                              as ImageProvider,
                      radius: 70,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      width: 330,
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          labelText: 'Email',
                          labelStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 16.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: 330,
                      child: TextField(
                        controller: _fullnameController,
                        decoration: InputDecoration(
                          hintText: 'Enter your fullname',
                          labelText: 'Fullname',
                          labelStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 16.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Row(
                          children: [
                            const Text(
                              "Is_Admin: ",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              superuser ? "Yes" : "No",
                              style: TextStyle(
                                fontSize: 20,
                                color: superuser ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            const Text(
                              "Date Joined: ",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              dateJoinedDate,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            const Text(
                              "Last Login: ",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              lastLoginDate,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      visible: hasError,
                      child: Text(
                        error_,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.red.shade500,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: hasError,
                      child: const SizedBox(
                        height: 20,
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: ElevatedButton(
                        onPressed: () {
                          updateAccount(id, access, _emailController.text,
                                  _fullnameController.text)
                              .then((value) {
                            if (value["success"]) {
                              Navigator.of(context)
                                  .pushReplacementNamed("/my_profile");
                            } else {
                              setState(() {
                                hasError = true;
                                error_ = value["error"];
                              });
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: const BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.update),
                            SizedBox(width: 10.0),
                            Text(
                              'Update Information',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: 250,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed("/change_password");
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: const BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.password_outlined),
                            SizedBox(width: 10.0),
                            Text(
                              'Change Password',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: 250,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<UserInfoNotifier>().logoutProcess();
                          deleteAccount(id, access).then((value) {
                            if (!value["success"]) {
                              setState(() {
                                hasError = true;
                                error_ = value["error"];
                              });
                            }
                          });
                          Navigator.of(context).pushReplacementNamed("/home");
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: const BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete_outline),
                            SizedBox(width: 10.0),
                            Text(
                              'Delete Account',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// date_joined & last_login