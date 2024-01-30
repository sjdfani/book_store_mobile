import 'package:book_store_mobile/api/book_api.dart';
import 'package:book_store_mobile/basic/popular_book_widget.dart';
import 'package:book_store_mobile/basic/providers.dart';
import 'package:book_store_mobile/models/book_model.dart';
import 'package:book_store_mobile/pages/home/book_list.dart';
import 'package:book_store_mobile/pages/home/book_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Book>> popular;
  late Future<List<Book>> newest;

  @override
  void initState() {
    super.initState();
    popular = getPopularBookList();
    newest = getNewestBookList();
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      popular = getPopularBookList();
      newest = getNewestBookList();
    });
  }

  Future<List<Book>> getPopularBookList() async {
    final books = await popularList(0);
    return books;
  }

  Future<List<Book>> getNewestBookList() async {
    final books = await newestList(0);
    return books;
  }

  @override
  Widget build(BuildContext context) {
    var userId = context.read<UserInfoNotifier>().userid;
    var access = context.read<UserInfoNotifier>().accesstoken;
    var logined = context.watch<UserInfoNotifier>().logined;
    var savedItemsList = context.watch<BookStoreNotifier>().savedItems;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            SizedBox(
              width: 135,
            ),
            Icon(
              Icons.home,
              color: Colors.black,
            ),
            SizedBox(width: 9),
            Text(
              "Home",
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
          Visibility(
            visible: !logined,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed("/login");
              },
              icon: const Icon(
                Icons.login,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: Colors.yellow,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Popular Books",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PublishBookList(
                            state: "popular",
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.more_horiz),
                  )
                ],
              ),
              FutureBuilder<List<Book>>(
                future: popular,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  return SizedBox(
                    height: 290,
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        var data = snapshot.data[index];
                        return PopularBook(
                          id: data.id,
                          imagepath: data.image,
                          title: data.title,
                          price: data.price.toString(),
                          author: data.author,
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Newest Books",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PublishBookList(
                            state: "newest",
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.more_horiz),
                  )
                ],
              ),
              FutureBuilder<List<Book>>(
                future: newest,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  return SizedBox(
                    height: 400,
                    child: ListView.builder(
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
                                    Text(
                                      data.title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      data.author,
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
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
                                    logined
                                        ? savedItemsList.contains(data.id)
                                            ? Icons.bookmark
                                            : Icons.bookmark_outline
                                        : Icons.login,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
