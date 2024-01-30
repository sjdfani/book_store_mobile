import 'package:book_store_mobile/api/book_api.dart';
import 'package:book_store_mobile/api/cart_api.dart';
import 'package:book_store_mobile/api/user_api.dart';
import 'package:book_store_mobile/basic/providers.dart';
import 'package:book_store_mobile/models/book_model.dart';
import 'package:book_store_mobile/models/shopping_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String error_ = "";
  bool hasError = false;

  List<int> idPurchaseItems = [];
  List<int> idSavedItems = [];

  Future<List<int>> extractNumbersFromCartList(String access) async {
    List<Cart> cartList = await getIDPurchaseItems(access);
    for (Cart cart in cartList) {
      idPurchaseItems.add(cart.bookId);
    }
    return idPurchaseItems;
  }

  Future<List<int>> extractNumbersFromSavedList(String access) async {
    List<SavedItem> savedItems = await getIDSavedItems(access);
    for (SavedItem saved in savedItems) {
      idSavedItems.add(saved.bookId);
    }
    return idSavedItems;
  }

  @override
  Widget build(BuildContext context) {
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
          "Login",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        titleTextStyle: const TextStyle(color: Colors.black),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              const Text(
                "Welcome back!",
                style: TextStyle(
                  fontSize: 35,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 330,
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: const TextStyle(
                      color: Colors.black,
                    ),
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
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    labelText: 'Password',
                    labelStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    hintStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.visibility),
                      onPressed: () {},
                    ),
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
                    login(_emailController.text, _passwordController.text)
                        .then((value) {
                      if (value["success"]) {
                        context.read<UserInfoNotifier>().loginProcess(
                            value["data"]["user"]["id"],
                            value["data"]["user"]["fullname"],
                            value["data"]["tokens"]["access"],
                            value["data"]["user"]["is_superuser"]);
                        extractNumbersFromCartList(
                            value["data"]["tokens"]["access"]);
                        context
                            .read<BookStoreNotifier>()
                            .setShoppingItem(idPurchaseItems);
                        extractNumbersFromSavedList(
                            value["data"]["tokens"]["access"]);
                        context
                            .read<BookStoreNotifier>()
                            .setSavedItem(idSavedItems);
                        Navigator.of(context).pushReplacementNamed("/home");
                      } else {
                        setState(() {
                          hasError = true;
                          error_ = value["error"];
                        });
                      }
                    }).catchError((onError) {
                      // ignore: avoid_print
                      print(onError);
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
                      Icon(Icons.login_outlined),
                      SizedBox(width: 10.0),
                      Text(
                        'Countinue',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: () {},
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/google_logo.png',
                        height: 30,
                      ),
                      const SizedBox(width: 10.0),
                      const Text(
                        'Login with Google',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                "Don't have an account?",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed("/register");
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
                      Icon(Icons.add_box_outlined),
                      SizedBox(width: 10.0),
                      Text(
                        'Create account',
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
