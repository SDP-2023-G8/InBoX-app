import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inbox_app/components/bars.dart';
import 'package:inbox_app/constants/constants.dart';
import 'package:inbox_app/pages/verify_code.dart';

import '../components/input_validation.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
            backgroundColor: PRIMARY_BLACK,
            appBar: const BarWithHelpAndBackArrow(
                'Change Password',
                'How to Change your Password',
                'Please use the email address you used to register.\n'
                    'Your new password must:\n'
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
                        cursorColor: PRIMARY_GREEN,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle:
                              TextStyle(color: PRIMARY_GREEN, fontSize: 24),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'Enter your email',
                          hintStyle:
                              TextStyle(fontSize: 18, color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: PRIMARY_GREEN)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: PRIMARY_GREY)),
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
                                  ? PRIMARY_GREEN
                                  : PRIMARY_RED)),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _isObscure1,
                        cursorColor: PRIMARY_GREEN,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                        decoration: InputDecoration(
                            labelText: 'New Password',
                            labelStyle: const TextStyle(
                                color: PRIMARY_GREEN, fontSize: 24),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: 'Create your new password',
                            hintStyle: const TextStyle(
                                fontSize: 18, color: Colors.grey),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: PRIMARY_GREEN)),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: PRIMARY_GREY)),
                            suffixIcon: IconButton(
                              color: PRIMARY_GREEN,
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
                              color:
                                  _input.min8 ? PRIMARY_GREEN : PRIMARY_RED)),
                      Text(
                          '${_input.lowerCase ? '•  ' : '× '}At least 1 small letter',
                          style: TextStyle(
                              fontSize: 17,
                              color: _input.lowerCase
                                  ? PRIMARY_GREEN
                                  : PRIMARY_RED)),
                      Text(
                          '${_input.upperCase ? '•  ' : '× '}At least 1 capital letter',
                          style: TextStyle(
                              fontSize: 17,
                              color: _input.upperCase
                                  ? PRIMARY_GREEN
                                  : PRIMARY_RED)),
                      Text('${_input.number ? '•  ' : '× '}At least 1 digit',
                          style: TextStyle(
                              fontSize: 17,
                              color:
                                  _input.number ? PRIMARY_GREEN : PRIMARY_RED)),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: _repeatPasswordController,
                        obscureText: _isObscure2,
                        cursorColor: PRIMARY_GREEN,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                        decoration: InputDecoration(
                            labelText: 'New Password',
                            labelStyle: const TextStyle(
                                color: PRIMARY_GREEN, fontSize: 24),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: 'Repeat your new password',
                            hintStyle: const TextStyle(
                                fontSize: 18, color: Colors.grey),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: PRIMARY_GREEN)),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: PRIMARY_GREY)),
                            suffixIcon: IconButton(
                              color: PRIMARY_GREEN,
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
                              color: _passwordsMatch
                                  ? PRIMARY_GREEN
                                  : PRIMARY_RED)),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(220, 50),
                              backgroundColor:
                                  (isEmailValid(_emailController.text) &&
                                          isPasswordValid(
                                              _passwordController.text) &&
                                          _passwordsMatch)
                                      ? PRIMARY_GREEN
                                      : Colors.grey),
                          onPressed: () async {
                            if (isEmailValid(_emailController.text) &&
                                isPasswordValid(_passwordController.text) &&
                                _passwordsMatch) {
                              // TODO: check for an existing email in the database
                              var url = Uri.http(
                                  REST_ENDPOINT, '/api/v1/users/register');
                              Map data = {
                                "email": _emailController.text,
                                "password": _passwordController.text
                              };
                              var response = await http.post(url,
                                  headers: {"Content-Type": "application/json"},
                                  body: json.encode(data));

                              if (response.statusCode == 201 &&
                                  context.mounted) {
                                // Send email verification code
                                var url = Uri.http(REST_ENDPOINT,
                                    '/api/v1/users/${_emailController.text}/verification');
                                http.get(url);

                                // Save authentication token
                                const storage = FlutterSecureStorage();
                                storage.write(
                                    key: "jwt",
                                    value: json.decode(response.body)["token"]);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VerificationScreen(
                                          'Change Password',
                                          _emailController.text)),
                                );
                              }
                            }
                          },
                          child: const Text(
                            'Change password',
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
