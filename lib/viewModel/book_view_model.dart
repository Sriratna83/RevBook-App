import 'dart:convert';

import 'package:revbook_app/models/api/book_api.dart' as book_api;

import 'package:revbook_app/models/book.dart';

import 'package:flutter/material.dart';

class Books with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final int rating;
  final String imageUrl;
  final String creatorId;

  bool isBookmark;

  Books({
    required this.id,
    required this.title,
    required this.description,
    required this.rating,
    required this.imageUrl,
    required this.creatorId,
    this.isBookmark = false,
  });

  Future<void> toggleBookmarkStatus(String authToken, String userId) async {
    try {
      await book_api.setStatus(
        bookId: id,
        status: !isBookmark,
        authToken: authToken,
        userId: userId,
      );

      isBookmark = !isBookmark;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}

class BookViewModel with ChangeNotifier {
  List<Books> books;

  final String authToken;
  final String userId;

  BookViewModel(this.authToken, this.userId, this.books);

  List<Books> get items {
    return [...books];
  }

  List<Books> get bookmarkItems {
    return books.where((book) => book.isBookmark).toList();
  }

  Future<void> addBook(Book book) async {
    try {
      final result = await book_api.addBook(book, authToken, userId);

      final Books newBook = Books(
        id: result['name'],
        title: book.title,
        description: book.description,
        rating: book.rating,
        imageUrl: book.imageUrl,
        creatorId: userId,
      );
      books.insert(0, newBook);
      notifyListeners();
    } catch (e) {
      rethrow;
    }

    return Future.value();
  }

  Future<void> loadAndSetBooks({bool filterByUserId = false}) async {
    try {
      if (authToken == "") {
        return;
      }

      final Map<String, dynamic>? result = await book_api.loadAllBooks(
        filterByUserId: filterByUserId,
        authToken: authToken,
        userId: userId,
      );

      if (result == null) return;

      final userBookmarkResponse =
          await book_api.userBookmarkBooks(authToken, userId);
      final userBookmark = json.decode(userBookmarkResponse.toString());

      final List<Books> loadedBooks = [];
      result.forEach((key, value) {
        loadedBooks.add(Books(
          id: key.toString(),
          title: value["title"],
          description: value["description"].toString(),
          rating: value["rating"],
          imageUrl: value["imageUrl"].toString(),
          creatorId: userId,
          isBookmark: userBookmark == null ? false : userBookmark[key] ?? false,
        ));
      });

      books.clear();
      books.addAll(loadedBooks);

      notifyListeners();
    } catch (e) {
      // print(e);
      rethrow;
    }
  }

  Future<void> updateBook(Book book) async {
    try {
      final int bookIndex = books.indexWhere((book) => book.id == book.id);

      if (bookIndex < 0) return;

      final response = await book_api.patchBook(book, authToken);
      // print("response[isFavorite]: ${response}");

      books[bookIndex] = Books(
        id: book.id.toString(),
        title: response["title"],
        description: response["description"],
        rating: response["rating"],
        imageUrl: response["imageUrl"],
        creatorId: userId,
      );

      notifyListeners();
    } catch (e) {
      print("updateBook $e");
      rethrow;
    }
  }

  Future<void> removeBook(String id) async {
    try {
      await book_api.deleteBook(id, authToken);

      int index = books.indexWhere((book) => book.id == id);

      books.removeAt(index);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Books findById(String id) {
    return books.firstWhere((book) => book.id == id);
  }
}
