import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = "SplashScreen";
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
