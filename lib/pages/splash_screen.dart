import 'dart:io';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  _navigatetohome() async {
    await Future.delayed(const Duration(seconds: 1), () {});
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, "/navigator");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 111, 170, 218),
              Color.fromARGB(234, 255, 241, 118)
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: ClipRRect( // Wrap the Image with ClipRRect
              borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
              child: const Image(
                image: AssetImage("assets/images/logo2.jpeg"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}