import 'dart:convert';
import 'package:revbook_app/models/book.dart';
import 'package:dio/dio.dart';
import 'package:revbook_app/models/http_exception.dart';

const String _defaultPath = "revbook-app-a5a45-default-rtdb.firebaseio.com";

Future<dynamic> addBook(Book book, String authToken, String creatorId) async {
  try {
    final Uri url = Uri.https(
      _defaultPath,
      "/books.json",
      {
        "auth": authToken,
      },
    );

    var http = Dio();

    final response = await http.postUri(url,
        data: json.encode(
          {
            "title": book.title,
            "description": book.description,
            "creatorId": creatorId,
            "rating": book.rating,
            "imageUrl": book.imageUrl,
            "isBookmark": book.isBookmark
          },
        ));

    return json.decode(response.toString());
  } catch (e) {
    throw HttpException(message: e.toString());
  }
}

Future<dynamic> loadAllBooks({
  required filterByUserId,
  required String authToken,
  required String userId,
}) async {
  try {
    Map<String, String> query = {"auth": authToken};
    if (filterByUserId) {
      query.addAll({
        "orderBy": '"creatorId"',
        "equalTo": '"$userId"',
      });
    }

    final Uri url = Uri.https(
      _defaultPath,
      "/books.json",
      query,
    );

    // print(url);
    final http = Dio();

    final response = await http.getUri(url);

    return json.decode(response.toString());
  } catch (e) {
    // print(e);
    throw HttpException(message: e.toString());
  }
}

Future<dynamic> patchBook(Book book, String authToken) async {
  try {
    final Uri url = Uri.https(
      _defaultPath,
      "/books/${book.id}.json",
      {
        "auth": authToken,
      },
    );

    // print(url);

    final http = Dio();
    final response = await http.patchUri(url,
        data: json.encode(
          {
            "title": book.title,
            "description": book.description,
            "rating": book.rating,
            "imageUrl": book.imageUrl,
          },
        ));

    return json.decode(response.toString());
  } catch (e) {
    throw HttpException(message: e.toString());
  }
}

Future<dynamic> deleteBook(String id, String authToken) async {
  try {
    final Uri url = Uri.https(
      _defaultPath,
      "/books/$id.json",
      {
        "auth": authToken,
      },
    );

    final http = Dio();
    await http.deleteUri(url);

    return;
  } catch (e) {
    throw HttpException(message: e.toString());
  }
}

Future<dynamic> userBookmarkBooks(String authToken, String userId) async {
  try {
    final url = Uri.https(
      _defaultPath,
      "/userBookmarks/$userId.json",
      {
        "auth": authToken,
      },
    );

    final response = await Dio().getUri(url);

    return response;
  } catch (e) {
    rethrow;
  }
}

Future<dynamic> setStatus(
    {required String bookId,
    required bool status,
    required String authToken,
    required String userId}) async {
  try {
    final url = Uri.https(
      _defaultPath,
      "/userBookmarks/$userId/$bookId.json",
      {
        "auth": authToken,
      },
    );
    final http = Dio();

    await http.putUri(
      url,
      data: json.encode(
        status,
      ),
    );

    return;
  } catch (e) {
    // print(e);
    HttpException(message: e.toString());
  }
}
