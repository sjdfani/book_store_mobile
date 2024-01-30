import 'package:book_store_mobile/api/book_api.dart';
import 'package:book_store_mobile/basic/providers.dart';
import 'package:book_store_mobile/models/book_model.dart';
import 'package:book_store_mobile/pages/home/book_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  late Future<List<Book>> books;
  bool hasData = false;

  @override
  void initState() {
    super.initState();
    var access = context.read<UserInfoNotifier>().accesstoken;
    books = getSavedItemsList(access);
    setState(() {
      hasData = true;
    });
  }

  Future<List<Book>> getSavedItemsList(String access) async {
    final books = await listSavedBook(access);
    return books;
  }

  @override
  Widget build(BuildContext context) {
    var userId = context.read<UserInfoNotifier>().userid;
    var access = context.read<UserInfoNotifier>().accesstoken;
    var logined = context.watch<UserInfoNotifier>().logined;
    var savedItemsList = context.watch<BookStoreNotifier>().savedItems;
    var hasSavedItemsData =
        context.watch<BookStoreNotifier>().hasSavedItemsData;

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
              width: 55,
            ),
            Icon(
              Icons.bookmark,
              color: Colors.black,
            ),
            SizedBox(width: 9),
            Text(
              "Saved Items",
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
      body: !hasSavedItemsData
          ? const Center(
              child: Text(
                "No Saved Items",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            )
          : Center(
              child: FutureBuilder<List<Book>>(
                future: books,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      var data = snapshot.data[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BookDetail(
                                id: data.id,
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
                                      data.image,
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
                                    data.title,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    data.author,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "\$${data.price.toString()}.00",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.blue[800],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "${data.numberOfPages.toString()} Pages",
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "⭐️ ${data.rating.toString()}",
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  if (logined) {
                                    if (savedItemsList.contains(data.id)) {
                                      deleteSavedBook(userId, data.id, access)
                                          .then(
                                        (value) {
                                          if (value["success"]) {
                                            context
                                                .read<BookStoreNotifier>()
                                                .removeSavedItem(data.id);
                                          }
                                        },
                                      );
                                    } else {
                                      createSavedBook(userId, data.id, access)
                                          .then(
                                        (value) {
                                          if (value["success"]) {
                                            context
                                                .read<BookStoreNotifier>()
                                                .addSavedItem(data.id);
                                          }
                                        },
                                      );
                                    }
                                  } else {
                                    Navigator.of(context)
                                        .pushReplacementNamed("/login");
                                  }
                                },
                                icon: Icon(
                                  savedItemsList.contains(data.id)
                                      ? Icons.bookmark
                                      : Icons.bookmark_outline,
                                  color: Colors.black,
                                ),
                              ),
                            ],
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
