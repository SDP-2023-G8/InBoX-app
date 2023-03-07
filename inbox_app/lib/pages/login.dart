import 'package:flutter/material.dart';
import 'package:inbox_app/components/bars.dart';
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
            appBar: const SimpleBarWithBackArrow('Login'),
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
                            hintText: 'Create your password',
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
                              : 'Incorrect email or password.',
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
                          onPressed: () {
                            // TODO: real authentication
                            if (_emailController.text == 'ddd@gmail.com' &&
                                _passwordController.text == 'Abcd1234') {
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
                          ))
                    ],
                  )),
                ),
              )
            ])));
  }
}
