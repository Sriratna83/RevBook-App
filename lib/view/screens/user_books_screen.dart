import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revbook_app/view/screens/edit_book_screen.dart';
import 'package:revbook_app/viewModel/book_view_model.dart';
import 'package:revbook_app/view/widgets/app_drawer.dart';
import 'package:revbook_app/view/widgets/user_book_list_item.dart';

class UserBooksScreen extends StatelessWidget {
  const UserBooksScreen({Key? key}) : super(key: key);

  static const String routeName = "UserBooksScreen";

  Future<void> _refreshBooks(BuildContext context) async {
    await Provider.of<BookViewModel>(context, listen: false).loadAndSetBooks(
      filterByUserId: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Books'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditBookScreen.routeName);
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
          future: _refreshBooks(context),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return RefreshIndicator(
                onRefresh: () => _refreshBooks(context),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Consumer<BookViewModel>(builder: (ctx, books, _) {
                    if (books.items.isEmpty) {
                      return const Center(
                        child: Text("No Data..."),
                      );
                    }

                    return ListView.builder(
                      itemCount: books.items.length,
                      itemBuilder: (_, index) => Column(
                        children: [
                          UserBookListItem(
                            id: books.items[index].id,
                            title: books.items[index].title,
                            imageUrl: books.items[index].imageUrl,
                          ),
                          const Divider(),
                        ],
                      ),
                    );
                  }),
                ),
              );
            }
          },
        ));
  }
}
