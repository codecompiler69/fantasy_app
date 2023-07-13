import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/main_page.dart';
import '../screens/welcome_screen.dart';

class CheckForSignIn extends StatelessWidget {
  const CheckForSignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const MainPage();
        } else {
          return const WelcomeScreen();
        }
      },
    );
  }
}
