import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:revbook_app/viewModel/book_view_model.dart';

class BookDetailScreen extends StatelessWidget {
  static const String routeName = "BookDetailScreen";

  final String? title;

  const BookDetailScreen({
    Key? key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context)!.settings.arguments as String;

    final book = Provider.of<BookViewModel>(
      context,
      listen: false,
    ).findById(id);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200),
        child: AppBar(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          flexibleSpace: Hero(
            tag: book.title,
            child: Container(
              height: 600,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: NetworkImage(book.imageUrl), fit: BoxFit.cover)),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    book.title,
                    style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.star, color: Colors.orange.shade700, size: 20),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    '${book.rating}',
                    style: TextStyle(
                        color: Colors.orange.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(
                thickness: 1.5,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Review book",
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                book.description,
                style: const TextStyle(color: Colors.grey, height: 1.5),
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
