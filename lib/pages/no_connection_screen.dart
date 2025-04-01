import 'package:flutter/material.dart';

class NoConnectionScreen extends StatelessWidget {
  const NoConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/connection.jpg"),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "You are not connected to internet. Please turn on the Mobile data or connect to wifi to continue further.\nThank You!",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      )),
    ));
  }
}
