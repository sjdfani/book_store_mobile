import 'package:book_store_mobile/api/book_api.dart';
import 'package:book_store_mobile/api/cart_api.dart';
import 'package:book_store_mobile/basic/providers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class BookDetail extends StatefulWidget {
  int id;
  BookDetail({super.key, required this.id});

  @override
  State<BookDetail> createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  String image = "", title = "", author = "", language = "", description = "";
  int numOfPages = 0, price = 0;
  double rating = 0.0;

  bool hasData = false;

  @override
  void initState() {
    super.initState();
    retrieveABook(
      widget.id,
    ).then((value) {
      title = value["data"]["title"];
      author = value["data"]["author"];
      rating = value["data"]["rating"];
      numOfPages = value["data"]["number_of_pages"];
      language = value["data"]["language"];
      description = value["data"]["description"];
      price = value["data"]["price"];
      image = value["data"]["image"];
      if (value["success"]) {
        setState(() {
          hasData = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var userId = context.read<UserInfoNotifier>().userid;
    var access = context.read<UserInfoNotifier>().accesstoken;
    var logined = context.watch<UserInfoNotifier>().logined;
    var savedItemsList = context.watch<BookStoreNotifier>().savedItems;
    var shoppingItemsList = context.watch<BookStoreNotifier>().shoppingItems;

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
              width: 55,
            ),
            Icon(
              Icons.book_outlined,
              color: Colors.black,
            ),
            SizedBox(width: 9),
            Text(
              "Book Detail",
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
        actions: [
          IconButton(
            onPressed: () {
              if (logined) {
                if (savedItemsList.contains(widget.id)) {
                  deleteSavedBook(userId, widget.id, access).then(
                    (value) {
                      if (value["success"]) {
                        context
                            .read<BookStoreNotifier>()
                            .removeSavedItem(widget.id);
                      }
                    },
                  );
                } else {
                  createSavedBook(userId, widget.id, access).then(
                    (value) {
                      if (value["success"]) {
                        context
                            .read<BookStoreNotifier>()
                            .addSavedItem(widget.id);
                      }
                    },
                  );
                }
              } else {
                Navigator.of(context).pushReplacementNamed("/login");
              }
            },
            icon: Icon(
              logined
                  ? savedItemsList.contains(widget.id)
                      ? Icons.bookmark
                      : Icons.bookmark_outline
                  : Icons.login,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: !hasData
          ? const CircularProgressIndicator()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Image(
                        image: CachedNetworkImageProvider(image),
                        fit: BoxFit.cover,
                        height: 300,
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    Text(
                      "\$ $price.00",
                      style: TextStyle(
                        fontSize: 19,
                        color: Colors.blue[800],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      author,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            const Text(
                              "Rating",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              rating.toString(),
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: [
                            const Text(
                              "Number of pages",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "${numOfPages.toString()} Pages",
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: [
                            const Text(
                              "Language",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              language.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            onPressed: () {},
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
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.book_outlined,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Text(
                                  "Preview",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            onPressed: () {},
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
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.comment_outlined,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Text(
                                  "Reviews",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () {
                          if (logined) {
                            if (!shoppingItemsList.contains(widget.id)) {
                              createPurchaseItem(widget.id, 1, access)
                                  .then((value) {
                                if (value["success"]) {
                                  setState(() {
                                    context
                                        .read<BookStoreNotifier>()
                                        .addShoppingItem(widget.id);
                                  });
                                }
                              });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor:
                              shoppingItemsList.contains(widget.id) || !logined
                                  ? Colors.grey.shade300
                                  : Colors.blue.shade300,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          backgroundColor: Colors.white,
                          side: const BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_shopping_cart_outlined,
                              color: shoppingItemsList.contains(widget.id) ||
                                      !logined
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Add to cart",
                              style: TextStyle(
                                fontSize: 15,
                                color: shoppingItemsList.contains(widget.id) ||
                                        !logined
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
