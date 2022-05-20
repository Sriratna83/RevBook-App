import 'package:flutter/material.dart';
import 'package:revbook_app/view/screens/book_detail_screen.dart';
import 'package:revbook_app/viewModel/book_view_model.dart';

class CustomSearch extends SearchDelegate<String> {
  final List<Books> items;

  CustomSearch(this.items);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, 'tidak ada');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Scaffold();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = items
        .where(
          (i) => i.title.toLowerCase().startsWith(
                query.toLowerCase(),
              ),
        )
        .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) => ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(suggestionList[index].imageUrl),
        ),
        onTap: () {
          Navigator.of(context).popAndPushNamed(BookDetailScreen.routeName,
              arguments: suggestionList[index].id);
        },
        title: RichText(
          text: TextSpan(
            text: suggestionList[index].title.substring(0, query.length),
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                  text: suggestionList[index].title.substring(query.length),
                  style: const TextStyle(color: Colors.grey))
            ],
          ),
        ),
      ),
    );
  }
}
