import 'package:flutter/material.dart';
import 'package:inbox_app/components/bars.dart';
import 'package:inbox_app/pages/verify_code.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
            appBar: const BarWithHelp('Register', 'How to Register?',
                'Please use a valid email address.'),
            body: CustomScrollView(slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                      child: Column(
                    children: [
                      const Text('registration screen'),
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
