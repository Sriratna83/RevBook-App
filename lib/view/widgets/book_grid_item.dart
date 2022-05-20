import 'package:revbook_app/models/book.dart';
import 'package:revbook_app/view/screens/book_detail_screen.dart';
import 'package:revbook_app/viewModel/auth_view_model.dart';

import 'package:revbook_app/viewModel/book_view_model.dart';

import 'package:revbook_app/view/widgets/image_handler_error.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookGridItem extends StatelessWidget {
  const BookGridItem({Key? key}) : super(key: key);

  Future<void> _toggleFavoriteStatus(BuildContext context) async {
    try {
      final viewModel = Provider.of<AuthViewModel>(
        context,
        listen: false,
      );

      await Provider.of<Books>(
        context,
        listen: false,
      ).toggleBookmarkStatus(viewModel.token!, viewModel.userId!);
    } catch (e) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            "Error",
            style: TextStyle(color: Theme.of(context).errorColor),
          ),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Okay"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final book = Provider.of<Books>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(BookDetailScreen.routeName, arguments: book.id);
        },
        child: GridTile(
          child: Hero(
            tag: book.id,
            child: ImageHandlerError(
              imageUrl: book.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black.withOpacity(0.7),
            leading: Consumer<Books>(builder: (ctx, book, _) {
              return IconButton(
                icon: Icon(
                    book.isBookmark ? Icons.bookmark : Icons.bookmark_border),
                color: Theme.of(context).iconTheme.color,
                onPressed: () {
                  _toggleFavoriteStatus(context);
                },
              );
            }),
            title: Text(
              book.title,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
