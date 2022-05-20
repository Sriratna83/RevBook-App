import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revbook_app/view/screens/edit_book_screen.dart';
import 'package:revbook_app/viewModel/book_view_model.dart';

class UserBookListItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  const UserBookListItem(
      {required this.id, required this.title, required this.imageUrl, Key? key})
      : super(key: key);

  void _deleteBook(BuildContext context) async {
    try {
      await Provider.of<BookViewModel>(context, listen: false).removeBook(id);
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
                child: const Text("Okay"))
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditBookScreen.routeName, arguments: id);
              },
              color: Theme.of(context).colorScheme.primary,
              icon: Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                // Provider.of<Books>(context, listen: false).removeBook(id);
                _deleteBook(context);
              },
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
