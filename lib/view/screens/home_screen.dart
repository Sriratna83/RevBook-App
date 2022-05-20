import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revbook_app/viewModel/book_view_model.dart';
import 'package:revbook_app/view/widgets/app_drawer.dart';
import 'package:revbook_app/view/widgets/books_grid.dart';
import 'package:revbook_app/view/widgets/search.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "HomeScreen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final bool _showOnlyFavorites = false;

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
    final viewModel = Provider.of<BookViewModel>(context, listen: false);

    if (!_isLoaded) {
      return const Center(child: CircularProgressIndicator());
    } else if (viewModel.items.isEmpty) {
      return const Center(child: Text("it's empty..."));
    } else {
      return BooksGrid(_showOnlyFavorites);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<BookViewModel>(context, listen: false).books;
    return Scaffold(
      appBar: AppBar(
        title: const Text('RevBook'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(context: context, delegate: CustomSearch(viewModel));
            },
          ),
        ],
      ),
      body: _buildScaffoldBody(context),
      drawer: const AppDrawer(),
    );
  }
}
