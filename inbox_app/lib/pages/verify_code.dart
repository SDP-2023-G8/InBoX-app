import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:inbox_app/components/bars.dart';
import 'package:inbox_app/pages/homepage.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen(this.title, this._emailAddress, {super.key});

  final String title;
  final String _emailAddress;

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  Color _codeColor = Colors.black;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              appBar: SimpleBar(widget.title),
              body: CustomScrollView(slivers: [
                SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: Column(children: [
                            Text(
                                'Please enter the 4-digit code sent to you at ${widget._emailAddress}.'),
                            Align(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    VerificationCode(
                                      textStyle: TextStyle(
                                        fontSize: 32.0,
                                        fontWeight: FontWeight.w500,
                                        color: _codeColor,
                                      ),
                                      underlineColor: Colors.deepPurple,
                                      keyboardType: TextInputType.number,
                                      length: 4,
                                      autofocus: true,
                                      digitsOnly: true,
                                      onCompleted: (String value) {
                                        if (value == "0808") {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const HomeScreen()),
                                          );
                                        } else {
                                          setState(() {
                                            _codeColor = Colors.red;
                                          });
                                        }
                                      },
                                      onEditing: (bool value) {
                                        if (value) {
                                          setState(() {
                                            _codeColor = Colors.black;
                                          });
                                        } else {
                                          FocusScope.of(context).unfocus();
                                        }
                                      },
                                    ),
                                  ],
                                ))
                          ]),
                        )))
              ])),
        ));
  }
}
