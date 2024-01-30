import 'package:book_store_mobile/api/book_api.dart';
import 'package:book_store_mobile/basic/providers.dart';
import 'package:book_store_mobile/models/book_model.dart';
import 'package:book_store_mobile/pages/home/book_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PublishBookList extends StatefulWidget {
  String state = "";
  PublishBookList({super.key, required this.state});

  @override
  State<PublishBookList> createState() => _PublishBookListState();
}

class _PublishBookListState extends State<PublishBookList> {
  late Future<List<Book>> books;

  @override
  void initState() {
    super.initState();
    if (widget.state == "newest") {
      books = getNewestBookList();
    } else if (widget.state == "popular") {
      books = getPopularBookList();
    }
  }

  Future<List<Book>> getPopularBookList() async {
    final books = await popularList(1);
    return books;
  }

  Future<List<Book>> getNewestBookList() async {
    final books = await newestList(1);
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
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed("/home");
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Text(
          widget.state == "newest" ? "Newest Books" : "Popular Books",
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        titleTextStyle: const TextStyle(color: Colors.black),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: Center(
        child: FutureBuilder<List<Book>>(
          future: books,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                var data = snapshot.data[index];
                return SizedBox(
                  height: 100,
                  child: Card(
                    color: Colors.grey.shade200,
                    child: ListTile(
                      leading: Container(
                        width: 70,
                        height: 250,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(data.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          if (logined) {
                            if (savedItemsList.contains(data.id)) {
                              deleteSavedBook(userId, data.id, access).then(
                                (value) {
                                  if (value["success"]) {
                                    context
                                        .read<BookStoreNotifier>()
                                        .removeSavedItem(data.id);
                                  }
                                },
                              );
                            } else {
                              createSavedBook(userId, data.id, access).then(
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
                      title: Text(
                        data.title,
                        style: const TextStyle(fontSize: 20),
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.author,
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                "\$${data.price.toString()}.00",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.blue[800],
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                "⭐️ ${data.rating.toString()}",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.blue[800],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BookDetail(
                              id: data.id,
                            ),
                          ),
                        );
                      },
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
