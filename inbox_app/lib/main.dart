import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inbox_app/constants/constants.dart';
import 'package:inbox_app/pages/deliveries.dart';
import 'package:inbox_app/pages/login.dart';
import 'package:inbox_app/pages/register.dart';
import 'package:inbox_app/pages/homepage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DeliveriesScreen(),
    );
  }
}

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  Future<void> keyValid() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: "jwt");

    try {
      var url = Uri.http(REST_ENDPOINT, "/api/v1/users/login/$token");
      var response = await http.get(url);

      if (response.statusCode == 201 &&
          json.decode(response.body)["result"] &&
          context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } on Exception catch (_) {
      // if exception occurs, just continue with regular login
    }
  }

  @override
  void initState() {
    super.initState();
    keyValid(); // Check if a key exists and whether it is valid
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
