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

  bool _isObscure1 = true;
  bool _isObscure2 = true;
  final CorrectPasswordInput _input = CorrectPasswordInput();
  bool _passwordsMatch = false;
  bool _isEmailValid = false;

  void callSetStateObscure(int pass) {
    setState(() {
      if (pass == 1) {
        _isObscure1 = !_isObscure1;
      } else if (pass == 2) {
        _isObscure2 = !_isObscure2;
      }
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

  void callSetStateMatch() {
    setState(() {
      _passwordsMatch =
          _passwordController.text == _repeatPasswordController.text;
    });
  }

  void callSetStateEmail() {
    setState(() {
      _isEmailValid = isEmailValid(_emailController.text);
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
                        onChanged: (value) => callSetStateEmail(),
                      ),
                      const SizedBox(height: 5),
                      Text(
                          (_isEmailValid || _emailController.text.isEmpty)
                              ? ''
                              : 'Invalid email address',
                          style: TextStyle(
                              fontSize: 17,
                              color: (_isEmailValid ||
                                      _emailController.text.isEmpty)
                                  ? Colors.green
                                  : Colors.red)),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _isObscure1,
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
                              icon: Icon(_isObscure1
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () => callSetStateObscure(1),
                            )),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (value) {
                          callSetStatePassword(validatePassword(value));
                          callSetStateMatch();
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text('${_input.min8 ? '•  ' : '× '}At least 8 characters',
                          style: TextStyle(
                              fontSize: 17,
                              color: _input.min8 ? Colors.green : Colors.red)),
                      Text(
                          '${_input.lowerCase ? '•  ' : '× '}At least 1 small letter',
                          style: TextStyle(
                              fontSize: 17,
                              color: _input.lowerCase
                                  ? Colors.green
                                  : Colors.red)),
                      Text(
                          '${_input.upperCase ? '•  ' : '× '}At least 1 capital letter',
                          style: TextStyle(
                              fontSize: 17,
                              color: _input.upperCase
                                  ? Colors.green
                                  : Colors.red)),
                      Text('${_input.number ? '•  ' : '× '}At least 1 digit',
                          style: TextStyle(
                              fontSize: 17,
                              color:
                                  _input.number ? Colors.green : Colors.red)),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _repeatPasswordController,
                        obscureText: _isObscure2,
                        cursorColor: Colors.deepPurple,
                        style: const TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(
                                color: Colors.deepPurple, fontSize: 24),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: 'Repeat your password',
                            hintStyle: const TextStyle(
                                fontSize: 18, color: Colors.grey),
                            focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.deepPurple)),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              color: Colors.deepPurple,
                              icon: Icon(_isObscure2
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () => callSetStateObscure(2),
                            )),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (value) {
                          callSetStateMatch();
                        },
                      ),
                      const SizedBox(height: 5),
                      Text(
                          (_passwordsMatch ||
                                  _repeatPasswordController.text.isEmpty)
                              ? ''
                              : 'Passwords do not match',
                          style: TextStyle(
                              fontSize: 17,
                              color:
                                  _passwordsMatch ? Colors.green : Colors.red)),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(120, 50),
                              backgroundColor: Colors.deepPurple,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)))),
                          onPressed: () {
                            if (isEmailValid(_emailController.text) &&
                                isPasswordValid(_passwordController.text) &&
                                _passwordsMatch) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VerificationScreen(
                                        'Register', _emailController.text)),
                              );
                            }
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
