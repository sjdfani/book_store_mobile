import 'package:book_store_mobile/api/cart_api.dart';
import 'package:book_store_mobile/basic/providers.dart';
import 'package:book_store_mobile/models/shopping_model.dart';
import 'package:book_store_mobile/pages/cart/checkout.dart';
import 'package:book_store_mobile/pages/home/book_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<List<PurchaseItems>> purchaseItems;
  bool hasData = false;

  @override
  void initState() {
    super.initState();
    var access = context.read<UserInfoNotifier>().accesstoken;
    purchaseItems = getOwenCart(access);
    setState(() {
      hasData = true;
    });
  }

  Future<List<PurchaseItems>> getOwenCart(String access) async {
    final items = await getCart(access, true);
    return items;
  }

  @override
  Widget build(BuildContext context) {
    var access = context.read<UserInfoNotifier>().accesstoken;
    var hasShoppingCartData =
        context.watch<BookStoreNotifier>().hasShoppingItemsData;

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
        title: const Row(
          children: [
            SizedBox(
              width: 85,
            ),
            Icon(
              Icons.shopping_cart,
              color: Colors.black,
            ),
            SizedBox(width: 9),
            Text(
              "Cart",
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
      body: !hasShoppingCartData
          ? const Center(
              child: Text(
                "No Cart Items",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            )
          : Center(
              child: FutureBuilder<List<PurchaseItems>>(
                future: purchaseItems,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      var data = snapshot.data[index];
                      return SingleChildScrollView(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BookDetail(
                                  id: data.book.id,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade300,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 100,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        data.book.image,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      data.book.title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      data.book.author,
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "⭐️ ${data.book.rating.toString()}",
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            if (data.count > 1) {
                                              changeCountPurchaseItem(
                                                data.id,
                                                data.count - 1,
                                                access,
                                              ).then((value) {
                                                if (value["success"]) {
                                                  setState(() {
                                                    purchaseItems =
                                                        getOwenCart(access);
                                                  });
                                                }
                                              });
                                            }
                                          },
                                          icon: Icon(
                                            Icons.remove,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                        Text(
                                          data.count.toString(),
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.blue[800],
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            changeCountPurchaseItem(
                                              data.id,
                                              data.count + 1,
                                              access,
                                            ).then((value) {
                                              if (value["success"]) {
                                                setState(() {
                                                  purchaseItems =
                                                      getOwenCart(access);
                                                });
                                              }
                                            });
                                          },
                                          icon: Icon(
                                            Icons.add,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            deletePurchaseItem(
                                              data.id,
                                              access,
                                            ).then((value) {
                                              if (value["success"]) {
                                                setState(() {
                                                  purchaseItems =
                                                      getOwenCart(access);
                                                });
                                                context
                                                    .read<BookStoreNotifier>()
                                                    .removeShoppingItem(
                                                      data.book.id,
                                                    );
                                              }
                                            });
                                          },
                                          icon: Icon(
                                            Icons.delete_outline,
                                            color: Colors.red.shade600,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 13,
                                        ),
                                        Text(
                                          "\$${(data.book.price * data.count).toString()}.00",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.blue[800],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
      bottomNavigationBar: Visibility(
        visible: hasShoppingCartData,
        child: Container(
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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CheckoutScreen(),
                ),
              );
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.credit_card_outlined,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Checkout",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
