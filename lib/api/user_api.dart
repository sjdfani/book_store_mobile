import 'dart:io';
import 'package:book_store_mobile/models/user_model.dart';
import 'package:dio/dio.dart';

const String baseUrl = "http://10.0.2.2:8001/api/v1/users";

Future<Map<String, dynamic>> login(String email, String password) async {
  try {
    Response response = await Dio().post(
      '$baseUrl/login/',
      data: {
        'email': email,
        'password': password,
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
        } else if (statusCode == 401) {
          return {"success": false, "error": errorMessage};
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

Future<Map<String, dynamic>> register(String email, String fullname,
    String password, String confirmPassword, File profile) async {
  FormData formData = FormData.fromMap({
    'profile': await MultipartFile.fromFile(
      profile.path,
      filename: '$fullname _profile.jpg',
    ),
    'email': email,
    'fullname': fullname,
    'password': password,
    'confirm_password': confirmPassword,
  });
  try {
    Response response = await Dio().post(
      '$baseUrl/register/',
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
            responseData['message'][0] ?? "An unexpected error occurred.";
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

Future<Map<String, dynamic>> retrieveAccount(int id, String access) async {
  try {
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $access';

    Response response = await dio.get(
      '$baseUrl/retrieve/$id/',
    );
    return {"success": true, "data": response.data};
  } catch (error) {
    return {
      "success": false,
      "error": "Something went wrong. Please try again."
    };
  }
}

Future<Map<String, dynamic>> updateAccount(
    int id, String access, String email, String fullname) async {
  try {
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $access';

    Response response = await dio.patch(
      '$baseUrl/retrieve/$id/',
      data: {
        "email": email,
        "fullname": fullname,
      },
    );
    return {"success": true, "data": response.data};
  } catch (error) {
    return {"success": false, "error": "This email was taken."};
  }
}

Future<Map<String, dynamic>> deleteAccount(int id, String access) async {
  try {
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $access';

    Response response = await dio.delete(
      '$baseUrl/retrieve/$id/',
    );
    return {"success": true, "data": response.data};
  } catch (error) {
    return {
      "success": false,
      "error": "Something went wrong. Please try again."
    };
  }
}

Future<Map<String, dynamic>> deleteAllAccount(int id, String access) async {
  try {
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $access';

    Response response = await dio.delete(
      '$baseUrl/list/$id/',
    );
    return {"success": true, "data": response.data};
  } catch (error) {
    return {
      "success": false,
      "error": "Something went wrong. Please try again."
    };
  }
}

Future<Map<String, dynamic>> changePassword(String currentPassword,
    String newPassword, String confirmPassword, String access) async {
  try {
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $access';

    Response response = await dio.post(
      '$baseUrl/change-password/',
      data: {
        'current_password': currentPassword,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      },
    );
    return {"success": true, "data": response.data};
  } catch (error) {
    if (error is DioError) {
      if (error.response != null) {
        final int statusCode = error.response!.statusCode!;
        if (statusCode == 400) {
          return {"success": false, "error": "Your password is incorrect."};
        } else if (statusCode == 401) {
          return {"success": false, "error": "Unauthorized."};
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

Future<List<User>> usersList(String access) async {
  Dio dio = Dio();
  dio.options.headers['Authorization'] = 'Bearer $access';

  Response response = await dio.get('$baseUrl/list/');
  var data = response.data.map<User>((json) {
    return User.fromJson(json);
  }).toList();
  return data;
}
