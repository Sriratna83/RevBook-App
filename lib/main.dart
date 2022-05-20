import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:revbook_app/helpers/custom_route.dart';
import 'package:revbook_app/view/screens/auth_screen.dart';
import 'package:revbook_app/view/screens/bookmark_screen.dart';
import 'package:revbook_app/view/screens/edit_book_screen.dart';
import 'package:revbook_app/view/screens/book_detail_screen.dart';
import 'package:revbook_app/view/screens/home_screen.dart';
import 'package:revbook_app/view/screens/splash_screen.dart';
import 'package:revbook_app/view/screens/user_books_screen.dart';
import 'package:revbook_app/viewModel/auth_view_model.dart';
import 'package:revbook_app/viewModel/book_view_model.dart';

void main() {
  runApp(const RevBook());
}

class RevBook extends StatelessWidget {
  const RevBook({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => AuthViewModel()),
          ChangeNotifierProxyProvider<AuthViewModel, BookViewModel>(
            create: (ctx) => BookViewModel("", "", []),
            update: (ctx, auth, previousState) => BookViewModel(
                auth.token ?? "",
                auth.userId ?? "",
                previousState == null ? [] : previousState.items),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.red,
            fontFamily: 'Lato',
            iconTheme: const IconThemeData(
              color: Colors.yellowAccent,
            ),
            textTheme:
                const TextTheme(headline6: TextStyle(color: Colors.white)),
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionBuilder()
            }),
          ),
          routes: {
            HomeScreen.routeName: (ctx) => const HomeScreen(),
            BookmarkScreen.routeName: (ctx) => const BookmarkScreen(),
            BookDetailScreen.routeName: (ctx) => const BookDetailScreen(),
            UserBooksScreen.routeName: (ctx) => const UserBooksScreen(),
            EditBookScreen.routeName: (ctx) => const EditBookScreen(),
            AuthScreen.routeName: (ctx) => const AuthScreen(),
            SplashScreen.routeName: (ctx) => const SplashScreen(),
          },
          home: Consumer<AuthViewModel>(
            builder: (ctx, authProvider, _) {
              return authProvider.isAuth
                  ? const HomeScreen()
                  // : AuthScreen();
                  : FutureBuilder(
                      future: authProvider.tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) {
                        if (authResultSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SplashScreen();
                        } else {
                          return const AuthScreen();
                        }
                      });
            },
          ),
        ));
  }
}
