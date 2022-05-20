import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revbook_app/view/screens/auth_screen.dart';
import 'package:revbook_app/view/screens/bookmark_screen.dart';
import 'package:revbook_app/view/screens/home_screen.dart';
import 'package:revbook_app/view/screens/user_books_screen.dart';
import 'package:revbook_app/viewModel/auth_view_model.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Hai'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.bookmark),
            title: const Text("Bookmark"),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(BookmarkScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.library_books),
            title: const Text("Library"),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserBooksScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text("Logout"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);

              Provider.of<AuthViewModel>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
