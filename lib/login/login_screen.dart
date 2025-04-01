import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool isLoading = false;
  FocusNode focusNode = FocusNode();
  final FirebaseAuth _auth = FirebaseAuth.instance;

   Future<void> login() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Navigator()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              color: Colors.white.withOpacity(0.7),
            ),
            Stack(
              children: [
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  CircleAvatar(
                      radius: width * 0.25,
                      backgroundColor: Colors.white,
                      child: Image.asset(
                        "assets/images/logo2.jpeg",
                      )),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  const Text(
                    "Welcome to",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "HP Tracker",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: width * 0.06),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  const Text(
                    "Enter your email id to login",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: width * 0.03, horizontal: width * 0.08),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Email id",
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(width * 0.04)),
                          borderSide: const BorderSide(),
                        ),
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const Text(
                    "Enter your password",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: width * 0.03, horizontal: width * 0.08),
                    child: TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: "Password",
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(width * 0.04)),
                          borderSide: const BorderSide(),
                        ),
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: login,
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: width * 0.045,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Not a user ?",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/registerScreen");
                        },
                        child: const Text("Register"),
                      ),
                    ],
                  )
                ]),
                isLoading
                    ? Container(
                        color: Colors.black.withOpacity(0.8),
                      )
                    : const SizedBox.shrink(),
                isLoading
                    ? Center(
                        child: Container(
                          color: Colors.white,
                          width: width * 0.6,
                          height: height * 0.2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: width * 0.1,
                                height: width * 0.1,
                                child: const CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Authenticating...',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: width * 0.04,
                              ),
                              const Text(
                                'Please Wait',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'This will take some time',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
