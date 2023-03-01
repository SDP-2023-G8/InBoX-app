import 'package:flutter/material.dart';
import 'package:inbox_app/pages/login.dart';
import 'package:inbox_app/pages/register.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: StartScreen(),
    );
  }
}

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, //Center Column contents vertically,
            crossAxisAlignment: CrossAxisAlignment
                .center, //Center Column contents horizontally,
            children: [
              const Center(
                  child: Image(
                image: AssetImage('assets/img/logo.png'),
                width: 250,
                height: 500,
              )),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(140, 50),
                    backgroundColor: Colors.deepPurple,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)))),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don\'t have an account yet?',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterScreen()),
                      );
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                  ),
                ],
              ),
            ]));
  }
}
