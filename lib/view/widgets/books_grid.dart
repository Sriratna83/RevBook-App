import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:revbook_app/viewModel/book_view_model.dart';
import 'package:revbook_app/view/widgets/book_grid_item.dart';

class BooksGrid extends StatelessWidget {
  bool showOnlyFavorites;

  BooksGrid(this.showOnlyFavorites);

  @override
  Widget build(BuildContext context) {
    final viewwModel = Provider.of<BookViewModel>(context);

    List<Books> books;

    if (showOnlyFavorites) {
      books = viewwModel.bookmarkItems;
    } else {
      books = viewwModel.items;
    }

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 3 / 4,
      ),
      itemCount: books.length,
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: books[index],
        child: const BookGridItem(),
      ),
    );
  }
}
