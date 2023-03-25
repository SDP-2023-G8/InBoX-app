import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:inbox_app/components/bars.dart';
import 'package:inbox_app/constants/constants.dart';
import 'package:inbox_app/pages/homepage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscure = true;
  bool _areDetailsCorrect = true;

  void callSetStateObscure() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  void callSetStateDetailsCorrect(bool areDetailsCorrect) {
    setState(() {
      _areDetailsCorrect = areDetailsCorrect;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar: const BarWithBackArrow('Login'),
            body: CustomScrollView(slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                      child: Column(
                    children: [
                      const SizedBox(height: 100),
                      TextFormField(
                        controller: _emailController,
                        cursorColor: Colors.deepPurple,
                        style: const TextStyle(fontSize: 18),
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle:
                              TextStyle(color: Colors.deepPurple, fontSize: 24),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'Enter your email',
                          hintStyle:
                              TextStyle(fontSize: 18, color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.deepPurple)),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (_) => callSetStateDetailsCorrect(true),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _isObscure,
                        cursorColor: Colors.deepPurple,
                        style: const TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(
                                color: Colors.deepPurple, fontSize: 24),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: 'Enter your password',
                            hintStyle: const TextStyle(
                                fontSize: 18, color: Colors.grey),
                            focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.deepPurple)),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              color: Colors.deepPurple,
                              icon: Icon(_isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () => callSetStateObscure(),
                            )),
                        onChanged: (_) => callSetStateDetailsCorrect(true),
                      ),
                      const SizedBox(height: 5),
                      Text(
                          _areDetailsCorrect
                              ? ''
                              : 'Incorrect email or password',
                          style: TextStyle(
                              fontSize: 17,
                              color: _areDetailsCorrect
                                  ? Colors.green
                                  : Colors.red)),
                      const SizedBox(height: 20),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(120, 50),
                              backgroundColor: Colors.deepPurple,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)))),
                          onPressed: () async {
                            var url =
                                Uri.http(REST_ENDPOINT, '/api/v1/users/login');
                            Map data = {
                              "email": _emailController.text,
                              "password": _passwordController.text
                            };
                            var response = await http.post(url,
                                headers: {"Content-Type": "application/json"},
                                body: json.encode(data));

                            if (response.statusCode == 201 && context.mounted) {
                              // Save new token
                              const storage = FlutterSecureStorage();
                              storage.write(
                                  key: "jwt",
                                  value: json.decode(response.body)["token"]);

                              callSetStateDetailsCorrect(true);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeScreen()),
                              );
                            } else {
                              callSetStateDetailsCorrect(false);
                            }
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 22, color: Colors.white),
                          )),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 17),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordScreen()),
                          );
                        },
                        child: const Text(
                          'Forgot your password?',
                          style: TextStyle(color: Colors.deepPurple),
                        ),
                      )
                    ],
                  )),
                ),
              )
            ])));
  }
}
