import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revbook_app/viewModel/book_view_model.dart';
import 'package:revbook_app/view/widgets/app_drawer.dart';
import 'package:revbook_app/view/widgets/books_grid.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({Key? key}) : super(key: key);
  static const String routeName = "BookmarkScreen";

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  final bool _showOnlyBookmark = true;

  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    if (!_isLoaded) {
      _loadBooks(context);
    }
    super.didChangeDependencies();
  }

  void _loadBooks(BuildContext context) async {
    try {
      await Provider.of<BookViewModel>(context, listen: false)
          .loadAndSetBooks(filterByUserId: false);
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
    } finally {
      if (mounted) {
        setState(() {
          _isLoaded = true;
        });
      }
    }
  }

  Widget _buildScaffoldBody(BuildContext context) {
    final modelView = Provider.of<BookViewModel>(context, listen: true);

    if (!_isLoaded) {
      return const Center(child: CircularProgressIndicator());
    } else if (modelView.items.isEmpty) {
      return const Center(child: Text("it's empty..."));
    } else {
      return BooksGrid(_showOnlyBookmark);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmark'),
      ),
      body: _buildScaffoldBody(context),
      drawer: const AppDrawer(),
    );
  }
}
