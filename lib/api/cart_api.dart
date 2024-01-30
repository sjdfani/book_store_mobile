import 'package:book_store_mobile/models/shopping_model.dart';
import 'package:dio/dio.dart';

const String baseUrl = "http://10.0.2.2:8001/api/v1/cart";

Future<Map<String, dynamic>> createPurchaseItem(
    int bookId, int count, String access) async {
  Dio dio = Dio();
  dio.options.headers['Authorization'] = 'Bearer $access';

  try {
    Response response = await dio.post(
      '$baseUrl/purchase_item/create/',
      data: {
        "book": bookId,
        "count": count,
      },
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

Future<List<PurchaseItems>> getCart(String access, bool status) async {
  Dio dio = Dio();
  dio.options.headers['Authorization'] = 'Bearer $access';

  Response response = await dio.get('$baseUrl/purchase_item/list/$status/');
  var data = response.data.map<PurchaseItems>((json) {
    return PurchaseItems.fromJson(json);
  }).toList();
  return data;
}

Future<Map<String, dynamic>> changeCountPurchaseItem(
    int purchaseItem, int count, String access) async {
  Dio dio = Dio();
  dio.options.headers['Authorization'] = 'Bearer $access';

  try {
    Response response = await dio.post(
      '$baseUrl/purchase_item/count/',
      data: {
        "purchase_item": purchaseItem,
        "count": count,
      },
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

Future<Map<String, dynamic>> deletePurchaseItem(
    int purchaseItem, String access) async {
  Dio dio = Dio();
  dio.options.headers['Authorization'] = 'Bearer $access';

  try {
    Response response = await dio.post(
      '$baseUrl/purchase_item/remove/',
      data: {
        "purchase_item": purchaseItem,
      },
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

Future<List<Cart>> getIDPurchaseItems(String access) async {
  Dio dio = Dio();
  dio.options.headers['Authorization'] = 'Bearer $access';

  Response response = await dio.get('$baseUrl/purchase_item/id/');
  var data = response.data.map<Cart>((json) {
    return Cart.fromJson(json);
  }).toList();
  return data;
}

Future<TotalPrice> getTotalPrice(String access) async {
  Dio dio = Dio();
  dio.options.headers['Authorization'] = 'Bearer $access';

  Response response = await dio.get('$baseUrl/payment/calculate/');
  var data = TotalPrice.fromJson(response.data);
  return data;
}

Future<Map<String, dynamic>> confirmPayment(String access) async {
  Dio dio = Dio();
  dio.options.headers['Authorization'] = 'Bearer $access';

  try {
    Response response = await dio.get(
      '$baseUrl/payment/confirm/',
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
