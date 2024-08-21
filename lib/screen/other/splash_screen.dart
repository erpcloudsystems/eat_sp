import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/user/user_provider.dart';
import '../home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (BuildContext context, userProvider, Widget? child) {
        return userProvider.user == null
            ? Center(
                child: FutureBuilder(
                    future: userProvider.getUserData(),
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const LoadingWidget();
                      }
                      return const LoginScreen();
                    }),
              )
            : const HomeScreen();
      },
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Image.asset("assets/logo.png"),
        ),
      ),
    );
  }
}
