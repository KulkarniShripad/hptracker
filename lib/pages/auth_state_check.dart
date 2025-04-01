import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hptracker/login/login_screen.dart';
import 'package:hptracker/pages/page_navigator.dart' show PageNavigator;

class AuthStateCheck extends StatefulWidget {
  const AuthStateCheck({super.key});

  @override
  State<AuthStateCheck> createState() => _AuthStateCheckState();
}

class _AuthStateCheckState extends State<AuthStateCheck> {

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const PageNavigator();
              } else {
                return const Login();
              }
            });
  }
}
