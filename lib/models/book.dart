class Book {
  String? id;
  String title;
  String description;
  int rating;
  String imageUrl;
  bool? isBookmark;

  Book({
    this.id,
    this.title = "",
    this.description = "",
    this.rating = 0,
    this.imageUrl = "",
    this.isBookmark,
  });

  Map toJson() => {'name': title, 'phone': description};

  // factory Book.fromJson(Map<String, dynamic> parsedJson) {
  //   return Book(
  //       id: parsedJson['id'],
  //       title: parsedJson['title'].toString(),
  //       description: parsedJson['description'].toString(),
  //       rating: parsedJson['rating'],
  //       imageUrl: parsedJson['imageUrl'].toString(),
  //       creatorId: parsedJson['creatorId'].toString());
  // }
  // Future<void> toggleBookmarkStatus(String authToken, String userId) async {
  //   try {
  //     await book_api.setStatus(
  //       bookId: id,
  //       status: !isBookmark,
  //       authToken: authToken,
  //       userId: userId,
  //     );

  //     isBookmark = !isBookmark;
  //     notifyListeners();
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
