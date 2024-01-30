import 'dart:io';
import 'package:book_store_mobile/models/book_model.dart';
import 'package:dio/dio.dart';

const String baseUrl = "http://10.0.2.2:8001/api/v1/books";

Future<Map<String, dynamic>> createBook(
  String access,
  String title,
  String author,
  int rating,
  int numberOfPages,
  String language,
  String description,
  int price,
  File image,
) async {
  Dio dio = Dio();
  dio.options.headers['Authorization'] = 'Bearer $access';

  FormData formData = FormData.fromMap({
    'image': await MultipartFile.fromFile(
      image.path,
      filename: '$title _image.jpg',
    ),
    'title': title,
    'author': author,
    'rating': rating,
    'number_of_pages': numberOfPages,
    'language': language,
    'description': description,
    'price': price,
  });

  try {
    Response response = await dio.post(
      '$baseUrl/create/',
      data: formData,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    );
    return {"success": true, "data": response.data};
  } catch (error) {
    if (error is DioError) {
      if (error.response != null) {
        final int statusCode = error.response!.statusCode!;
        final Map<String, dynamic> responseData = error.response!.data;
        final String errorMessage =
            responseData['message'] ?? "An unexpected error occurred.";
        if (statusCode == 400) {
          return {
            "success": false,
            "error": errorMessage,
          };
        } else {
          return {
            "success": false,
            "error": "An unexpected error occurred. Status code: $statusCode"
          };
        }
      } else {
        return {"success": false, "error": "No response received from server."};
      }
    } else {
      return {
        "success": false,
        "error": "Something went wrong. Please try again."
      };
    }
  }
}

Future<List<Book>> booksAllList(String access) async {
  Dio dio = Dio();
  dio.options.headers['Authorization'] = 'Bearer $access';

  Response response = await dio.get('$baseUrl/all/list/');
  var data = response.data.map<Book>((json) {
    return Book.fromJson(json);
  }).toList();
  return data;
}

Future<Map<String, dynamic>> deleteAllBook(int id, String access) async {
  try {
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $access';

    Response response = await dio.delete(
      '$baseUrl/all/list/$id/',
    );
    return {"success": true, "data": response.data};
  } catch (error) {
    return {
      "success": false,
      "error": "Something went wrong. Please try again."
    };
  }
}

Future<Map<String, dynamic>> retrieveBook(int id, String access) async {
  try {
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $access';

    Response response = await dio.get(
      '$baseUrl/all/list/$id/',
    );
    return {"success": true, "data": response.data};
  } catch (error) {
    return {
      "success": false,
      "error": "Something went wrong. Please try again."
    };
  }
}

Future<Map<String, dynamic>> retrieveABook(int id) async {
  try {
    Dio dio = Dio();

    Response response = await dio.get('$baseUrl/list/$id/');
    return {"success": true, "data": response.data};
  } catch (error) {
    return {
      "success": false,
      "error": "Something went wrong. Please try again."
    };
  }
}

Future<Map<String, dynamic>> updateBook(
  int id,
  String access,
  String title,
  String author,
  double rating,
  int numberOfPages,
  String language,
  String description,
  int price,
  bool publish,
) async {
  try {
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $access';

    Response response = await dio.patch(
      '$baseUrl/all/list/$id/',
      data: {
        'title': title,
        'author': author,
        'rating': rating,
        'number_of_pages': numberOfPages,
        'language': language,
        'description': description,
        'price': price,
        'publish': publish,
      },
    );
    return {"success": true, "data": response.data};
  } catch (error) {
    return {
      "success": false,
      "error": "Something went wrong. Please try again."
    };
  }
}

Future<List<Book>> popularList(int state) async {
  Dio dio = Dio();

  Response response = await dio.get('$baseUrl/popular/list/$state/');
  var data = response.data.map<Book>((json) {
    return Book.fromJson(json);
  }).toList();
  return data;
}

Future<List<Book>> newestList(int state) async {
  Dio dio = Dio();

  Response response = await dio.get('$baseUrl/newest/list/$state/');
  var data = response.data.map<Book>((json) {
    return Book.fromJson(json);
  }).toList();
  return data;
}

Future<Map<String, dynamic>> createSavedBook(
    int userId, int bookId, String access) async {
  try {
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $access';

    Response response = await dio.post(
      '$baseUrl/saveItem/create/',
      data: {
        "user": userId,
        "book": bookId,
      },
    );
    return {"success": true, "data": response.data};
  } catch (error) {
    return {
      "success": false,
      "error": "Something went wrong. Please try again."
    };
  }
}

Future<Map<String, dynamic>> deleteSavedBook(
    int userId, int bookId, String access) async {
  try {
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $access';

    Response response = await dio.post(
      '$baseUrl/saveItem/remove/',
      data: {
        "user": userId,
        "book": bookId,
      },
    );
    return {"success": true, "data": response.data};
  } catch (error) {
    return {
      "success": false,
      "error": "Something went wrong. Please try again."
    };
  }
}

Future<List<Book>> listSavedBook(String access) async {
  Dio dio = Dio();
  dio.options.headers['Authorization'] = 'Bearer $access';

  Response response = await dio.get('$baseUrl/saveItem/list/');
  var data = response.data.map<Book>((json) {
    return Book.fromJson(json["book"]);
  }).toList();
  return data;
}

Future<List<SavedItem>> getIDSavedItems(String access) async {
  Dio dio = Dio();
  dio.options.headers['Authorization'] = 'Bearer $access';

  Response response = await dio.get('$baseUrl/saveItem/id/');
  var data = response.data.map<SavedItem>((json) {
    return SavedItem.fromJson(json);
  }).toList();
  return data;
}
