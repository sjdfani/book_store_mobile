import 'package:book_store_mobile/api/book_api.dart';
import 'package:book_store_mobile/basic/providers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class BookDetail extends StatefulWidget {
  int id;
  BookDetail({super.key, required this.id});

  @override
  State<BookDetail> createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _numpageController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();
  final TextEditingController _descriptiongController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  String image = "", title = "", author = "", language = "", description = "";
  int numOfPages = 0, price = 0;
  double rating = 0.0;
  bool publish = false;

  bool hasData = false;

  String error_ = "";
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    retrieveBook(
      widget.id,
      context.read<UserInfoNotifier>().accesstoken,
    ).then((value) {
      title = value["data"]["title"];
      author = value["data"]["author"];
      rating = value["data"]["rating"];
      numOfPages = value["data"]["number_of_pages"];
      language = value["data"]["language"];
      description = value["data"]["description"];
      price = value["data"]["price"];
      image = value["data"]["image"];
      publish = value["data"]["publish"];
      if (value["success"]) {
        setState(() {
          hasData = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var access = context.read<UserInfoNotifier>().accesstoken;
    _titleController.text = title;
    _authorController.text = author;
    _ratingController.text = rating.toString();
    _numpageController.text = numOfPages.toString();
    _languageController.text = language;
    _descriptiongController.text = description;
    _priceController.text = price.toString();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed("/book_list");
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: const Text(
          "Book Detail",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        titleTextStyle: const TextStyle(color: Colors.black),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: !hasData
          ? const Center(
              child: Text(
                "There is a problem to load data.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 300,
                      width: 300,
                      child: Image(
                        image: CachedNetworkImageProvider(image),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      width: 330,
                      child: TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          hintText: 'Enter title',
                          hintStyle: TextStyle(color: Colors.grey.shade700),
                          labelText: 'Title',
                          labelStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          prefixIcon: const Icon(Icons.title),
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
                        controller: _authorController,
                        decoration: InputDecoration(
                          hintText: 'Enter author',
                          hintStyle: TextStyle(color: Colors.grey.shade700),
                          labelText: 'Author',
                          labelStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          prefixIcon: const Icon(Icons.person),
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
                        controller: _ratingController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          hintText: 'Enter rating',
                          hintStyle: TextStyle(color: Colors.grey.shade700),
                          labelText: 'Rating',
                          labelStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          prefixIcon: const Icon(Icons.rate_review),
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
                        controller: _numpageController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          hintText: 'Enter number of pages',
                          hintStyle: TextStyle(color: Colors.grey.shade700),
                          labelText: 'Number of Pages',
                          labelStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          prefixIcon: const Icon(Icons.numbers),
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
                        controller: _languageController,
                        decoration: InputDecoration(
                          hintText: 'Enter language',
                          hintStyle: TextStyle(color: Colors.grey.shade700),
                          labelText: 'Language',
                          labelStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          prefixIcon: const Icon(Icons.language),
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
                        controller: _descriptiongController,
                        decoration: InputDecoration(
                          hintText: 'Enter description',
                          hintStyle: TextStyle(color: Colors.grey.shade700),
                          labelText: 'Description',
                          labelStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          prefixIcon: const Icon(Icons.description),
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
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          hintText: 'Enter price',
                          hintStyle: TextStyle(color: Colors.grey.shade700),
                          labelText: 'Price',
                          labelStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          prefixIcon: const Icon(Icons.price_change),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Published:",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Checkbox(
                          value: publish,
                          onChanged: (value) {
                            setState(() {
                              publish = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    Visibility(
                      visible: hasError,
                      child: const SizedBox(
                        height: 20,
                      ),
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
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 250,
                      child: ElevatedButton(
                        onPressed: () {
                          updateBook(
                            widget.id,
                            access,
                            _titleController.text,
                            _authorController.text,
                            double.parse(_ratingController.text),
                            int.parse(_numpageController.text),
                            _languageController.text,
                            _descriptiongController.text,
                            int.parse(_priceController.text),
                            publish,
                          ).then((value) {
                            if (value["success"]) {
                              Navigator.of(context)
                                  .pushReplacementNamed("/book_list");
                            } else {
                              setState(() {
                                hasError = true;
                                error_ = value["error"];
                              });
                            }
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
                            Icon(Icons.add_box_outlined),
                            SizedBox(width: 10.0),
                            Text(
                              'Update',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
