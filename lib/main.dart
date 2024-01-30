import 'package:book_store_mobile/basic/providers.dart';
import 'package:book_store_mobile/pages/cart/cart.dart';
import 'package:book_store_mobile/pages/cart/checkout.dart';
import 'package:book_store_mobile/pages/more/books_list.dart';
import 'package:book_store_mobile/pages/more/create_book.dart';
import 'package:book_store_mobile/pages/home/home.dart';
import 'package:book_store_mobile/pages/home/login.dart';
import 'package:book_store_mobile/pages/more/more.dart';
import 'package:book_store_mobile/pages/more/user_list.dart';
import 'package:book_store_mobile/pages/profile/change_password.dart';
import 'package:book_store_mobile/pages/profile/my_past_order.dart';
import 'package:book_store_mobile/pages/profile/my_profile.dart';
import 'package:book_store_mobile/pages/profile/profile.dart';
import 'package:book_store_mobile/pages/home/register.dart';
import 'package:book_store_mobile/pages/more/settings.dart';
import 'package:book_store_mobile/pages/saved/saved.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SettingNotifier()),
      ChangeNotifierProvider(create: (_) => UserInfoNotifier()),
      ChangeNotifierProvider(create: (_) => BookStoreNotifier()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    var themeData = context.watch<SettingNotifier>().themeData;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeData,
      darkTheme: ThemeData.dark(),
      routes: <String, WidgetBuilder>{
        "/home": (BuildContext context) => const HomePage(),
        "/setting": (BuildContext context) => const Settings(),
        "/profile": (BuildContext context) => const ProfileScreen(),
        "/cart": (BuildContext context) => const CartScreen(),
        "/saved": (BuildContext context) => const SavedScreen(),
        "/more": (BuildContext context) => const MoreScreen(),
        "/login": (BuildContext context) => const Login(),
        "/register": (BuildContext context) => const Register(),
        "/create_book": (BuildContext context) => const CreateBook(),
        "/my_profile": (BuildContext context) => const MyProfile(),
        "/change_password": (BuildContext context) => const ChangePassword(),
        "/user_list": (BuildContext context) => const UserList(),
        "/book_list": (BuildContext context) => const BookList(),
        "/past_orders": (BuildContext context) => const MyPastOrders(),
        "/checkout": (BuildContext context) => const CheckoutScreen(),
      },
      initialRoute: "/home",
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedpage = 0;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<SettingNotifier>().loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    var logined = context.watch<UserInfoNotifier>().logined;

    final List<Widget> pages = [
      const HomeScreen(),
      const SavedScreen(),
      const CartScreen(),
      const ProfileScreen(),
      const MoreScreen(),
    ];

    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        body: pages[selectedpage],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedpage,
          onTap: (index) {
            if (index == 0 || index == 4) {
              setState(() {
                selectedpage = index;
              });
            } else if (logined) {
              setState(() {
                selectedpage = index;
              });
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              label: 'Home',
              backgroundColor:
                  Theme.of(context).bottomNavigationBarTheme.backgroundColor,
              activeIcon: Icon(
                Icons.home,
                color: Theme.of(context)
                    .bottomNavigationBarTheme
                    .selectedItemColor,
              ),
            ),
            BottomNavigationBarItem(
              icon: Opacity(
                opacity: logined ? 1.0 : 0.5,
                child: const Icon(
                  Icons.bookmark_outline,
                ),
              ),
              label: 'Saved',
              backgroundColor:
                  Theme.of(context).bottomNavigationBarTheme.backgroundColor,
              activeIcon: Icon(
                Icons.bookmark,
                color: Theme.of(context)
                    .bottomNavigationBarTheme
                    .selectedItemColor,
              ),
            ),
            BottomNavigationBarItem(
              icon: Opacity(
                opacity: logined ? 1.0 : 0.5,
                child: const Icon(
                  Icons.shopping_cart_outlined,
                ),
              ),
              label: 'Cart',
              backgroundColor:
                  Theme.of(context).bottomNavigationBarTheme.backgroundColor,
              activeIcon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context)
                    .bottomNavigationBarTheme
                    .selectedItemColor,
              ),
            ),
            BottomNavigationBarItem(
              icon: Opacity(
                opacity: logined ? 1.0 : 0.5,
                child: const Icon(Icons.person_outline),
              ),
              label: 'Profile',
              backgroundColor:
                  Theme.of(context).bottomNavigationBarTheme.backgroundColor,
              activeIcon: Icon(
                Icons.person,
                color: Theme.of(context)
                    .bottomNavigationBarTheme
                    .selectedItemColor,
              ),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.more_horiz_outlined),
              label: 'More',
              backgroundColor:
                  Theme.of(context).bottomNavigationBarTheme.backgroundColor,
              activeIcon: Icon(
                Icons.more_horiz,
                color: Theme.of(context)
                    .bottomNavigationBarTheme
                    .selectedItemColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
