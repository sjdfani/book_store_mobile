import 'package:book_store_mobile/api/book_api.dart';
import 'package:book_store_mobile/basic/providers.dart';
import 'package:book_store_mobile/models/book_model.dart';
import 'package:book_store_mobile/pages/more/book_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookList extends StatefulWidget {
  const BookList({super.key});

  @override
  State<BookList> createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  late Future<List<Book>> books;

  @override
  void initState() {
    super.initState();
    books = getBookList();
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      books = getBookList();
    });
  }

  Future<List<Book>> getBookList() async {
    String access = context.read<UserInfoNotifier>().accesstoken;
    final books = await booksAllList(access);
    return books;
  }

  @override
  Widget build(BuildContext context) {
    var access = context.read<UserInfoNotifier>().accesstoken;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed("/more");
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: const Text(
          "Book List",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        titleTextStyle: const TextStyle(color: Colors.black),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: RefreshIndicator(
        color: Colors.purple,
        onRefresh: _refreshData,
        child: Center(
          child: FutureBuilder<List<Book>>(
            future: books,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) return const CircularProgressIndicator();
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
                                style: const TextStyle(fontSize: 18),
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
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  deleteAllBook(data.id, access).then((value) {
                                    Navigator.of(context)
                                        .pushReplacementNamed("/book_list");
                                  });
                                },
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: Colors.red.shade700,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => BookDetail(
                                        id: data.id,
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.edit_outlined,
                                  color: Colors.green[800],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
