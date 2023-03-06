import 'package:flutter/material.dart';
import 'package:inbox_app/components/bars.dart';
import 'package:inbox_app/pages/verify_code.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();

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
                  child: Center(
                      child: Column(
                    children: [
                      const Text('registration screen'),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: 'Enter your email',
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const VerificationScreen(
                                          'Register', 'example@gmail.com')),
                            );
                          },
                          child: const Text('Register'))
                    ],
                  )),
                ),
              )
            ])));
  }
}
