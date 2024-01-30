import 'package:book_store_mobile/api/cart_api.dart';
import 'package:book_store_mobile/basic/providers.dart';
import 'package:book_store_mobile/models/shopping_model.dart';
import 'package:book_store_mobile/pages/cart/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late Future<List<PurchaseItems>> purchaseItems;

  bool hasData = false;
  int totalPrice = 0;

  List<int> idPurchaseItems = [];

  String error_ = "";
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    var access = context.read<UserInfoNotifier>().accesstoken;
    getTotalPriceFunc(access);
    purchaseItems = getOwenCart(access);
  }

  Future<List<PurchaseItems>> getOwenCart(String access) async {
    final items = await getCart(access, true);
    return items;
  }

  Future<TotalPrice> getTotalPriceFunc(String access) async {
    final items = await getTotalPrice(access);
    totalPrice = items.total_price;
    return items;
  }

  Future<List<int>> extractNumbersFromCartList(String access) async {
    List<Cart> cartList = await getIDPurchaseItems(access);
    for (Cart cart in cartList) {
      idPurchaseItems.add(cart.bookId);
    }
    return idPurchaseItems;
  }

  @override
  Widget build(BuildContext context) {
    var access = context.read<UserInfoNotifier>().accesstoken;
    var fullname = context.read<UserInfoNotifier>().fullname;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: const Row(
          children: [
            SizedBox(
              width: 75,
            ),
            Icon(
              Icons.credit_card,
              color: Colors.black,
            ),
            SizedBox(width: 9),
            Text(
              "Checkout",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
        titleTextStyle: const TextStyle(color: Colors.black),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "My Cart",
                  style: TextStyle(fontSize: 20),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CartScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.more_horiz),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Delivery Address",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                const Text(
                  "FullName: ",
                  style: TextStyle(
                    fontSize: 19,
                  ),
                ),
                Text(
                  fullname,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            const Row(
              children: [
                Text(
                  "Home Address: ",
                  style: TextStyle(
                    fontSize: 19,
                  ),
                ),
                Text(
                  "Fallahi Blv.",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            const Row(
              children: [
                Text(
                  "City: ",
                  style: TextStyle(
                    fontSize: 19,
                  ),
                ),
                Text(
                  "Mashhad",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            const Row(
              children: [
                Text(
                  "State: ",
                  style: TextStyle(
                    fontSize: 19,
                  ),
                ),
                Text(
                  "Khorasan Razavi",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            const Row(
              children: [
                Text(
                  "Country: ",
                  style: TextStyle(
                    fontSize: 19,
                  ),
                ),
                Text(
                  "Iran",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            const Row(
              children: [
                Text(
                  "Postal Code: ",
                  style: TextStyle(
                    fontSize: 19,
                  ),
                ),
                Text(
                  "12345-54321",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            const Row(
              children: [
                Text(
                  "Phone Number: ",
                  style: TextStyle(
                    fontSize: 19,
                  ),
                ),
                Text(
                  "+98 915 416 3622",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Payment Method",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "Debit Mastercard(7068)",
              style: TextStyle(
                fontSize: 19,
              ),
            ),
            const Text(
              "\t\t\t\t\t\tExp: 12/19",
              style: TextStyle(
                fontSize: 19,
              ),
            ),
            Text(
              "\t\t\t\t\t\t$fullname",
              style: const TextStyle(
                fontSize: 19,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total To Pay: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                  ),
                ),
                Text(
                  "\$${totalPrice.toString()}.00",
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 130,
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
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue.shade300,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  backgroundColor: Colors.white,
                  side: const BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                onPressed: () {
                  confirmPayment(access).then((value) {
                    if (value["success"]) {
                      extractNumbersFromCartList(access);
                      context
                          .read<BookStoreNotifier>()
                          .setShoppingItem(idPurchaseItems);
                      Navigator.of(context).pushReplacementNamed("/cart");
                    } else {
                      setState(() {
                        hasError = true;
                        error_ = "There is a problem here!!!";
                      });
                    }
                  });
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.payments_outlined,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Place Order",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
