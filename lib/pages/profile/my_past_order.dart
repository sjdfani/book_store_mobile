import 'package:book_store_mobile/api/cart_api.dart';
import 'package:book_store_mobile/basic/providers.dart';
import 'package:book_store_mobile/models/shopping_model.dart';
import 'package:book_store_mobile/pages/home/book_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyPastOrders extends StatefulWidget {
  const MyPastOrders({super.key});

  @override
  State<MyPastOrders> createState() => _MyPastOrdersState();
}

class _MyPastOrdersState extends State<MyPastOrders> {
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
    final items = await getCart(access, false);
    return items;
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Row(
          children: [
            SizedBox(
              width: 60,
            ),
            Icon(
              Icons.payment,
              color: Colors.black,
            ),
            SizedBox(width: 9),
            Text(
              "Past Orders",
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
      body: !hasData
          ? const Center(
              child: Text(
                "Cart is Empty!!!",
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
                                    Text(
                                      data.book.title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      data.book.author,
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "⭐️ ${data.book.rating.toString()}",
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Count: ",
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          data.count.toString(),
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.blue[800],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const Text(
                                          "&  Price a book: ",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          "\$${(data.price_of_one_book).toString()}.00",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.blue[800],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Total Price: ",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          "\$${(data.price_of_one_book * data.count).toString()}.00",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.blue[800],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Transaction ID: ",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          (data.transaction_id).toString(),
                                          style: const TextStyle(
                                            fontSize: 15,
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
    );
  }
}
