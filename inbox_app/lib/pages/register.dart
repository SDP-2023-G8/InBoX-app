import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inbox_app/components/bars.dart';
import 'package:inbox_app/pages/verify_code.dart';

import '../components/input_validation.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();

  bool _isObscure = true;
  CorrectPasswordInput _input = CorrectPasswordInput();
  void callSetStateObscure() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  void callSetStatePassword(CorrectPasswordInput input) {
    setState(() {
      _input.min8 = input.min8;
      _input.lowerCase = input.lowerCase;
      _input.upperCase = input.upperCase;
      _input.number = input.number;
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
            appBar: const BarWithHelp(
                'Register',
                'How to Register?',
                'Please use a valid email address.\n'
                    'Your password must:\n'
                    '- be at least 8 characters long,\n'
                    '- have at least one lower case letter,\n'
                    '- have at least one capital letter,\n'
                    '- have at least one digit.'),
            body: CustomScrollView(slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50),
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
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _isObscure,
                        cursorColor: Colors.deepPurple,
                        style: const TextStyle(fontSize: 18),
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (value) {
                          callSetStatePassword(validatePassword(value));
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text('${_input.min8 ? '• ' : '× '}Minimum 8 characters',
                          style: TextStyle(
                              fontSize: 17,
                              color: _input.min8 ? Colors.green : Colors.red)),
                      Text(
                          '${_input.lowerCase ? '• ' : '× '}At least 1 small letter',
                          style: TextStyle(
                              fontSize: 17,
                              color: _input.lowerCase
                                  ? Colors.green
                                  : Colors.red)),
                      Text(
                          '${_input.upperCase ? '• ' : '× '}At least 1 capital letter',
                          style: TextStyle(
                              fontSize: 17,
                              color: _input.upperCase
                                  ? Colors.green
                                  : Colors.red)),
                      Text('${_input.number ? '• ' : '× '}At least 1 digit',
                          style: TextStyle(
                              fontSize: 17,
                              color:
                                  _input.number ? Colors.green : Colors.red)),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _repeatPasswordController,
                        cursorColor: Colors.deepPurple,
                        style: const TextStyle(fontSize: 18),
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          labelStyle:
                              TextStyle(color: Colors.deepPurple, fontSize: 24),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'Repeat your password',
                          hintStyle:
                              TextStyle(fontSize: 18, color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.deepPurple)),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(120, 30),
                              backgroundColor: Colors.deepPurple,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)))),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VerificationScreen(
                                      'Register', _emailController.text)),
                            );
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ])));
  }
}
