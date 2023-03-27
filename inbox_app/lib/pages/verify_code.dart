import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:http/http.dart' as http;
import 'package:inbox_app/components/bars.dart';
import 'package:inbox_app/constants/constants.dart';
import 'package:inbox_app/pages/homepage.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen(this.title, this._emailAddress, {super.key});

  final String title;
  final String _emailAddress;

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  Color _codeColor = PRIMARY_GREEN;
  String _errorText = '';
  int _attemptsLeft = 5;

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
              backgroundColor: PRIMARY_BLACK,
              appBar: SimpleBar(widget.title),
              body: CustomScrollView(slivers: [
                SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(height: 200),
                              Text(
                                'Please enter the 4-digit code sent to you at\n${widget._emailAddress}.',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              VerificationCode(
                                textStyle: TextStyle(
                                  fontSize: 34,
                                  color: _codeColor,
                                ),
                                margin:
                                    const EdgeInsets.only(top: 20, bottom: 10),
                                underlineColor: PRIMARY_GREEN,
                                cursorColor: PRIMARY_GREEN,
                                keyboardType: TextInputType.number,
                                length: 4,
                                autofocus: true,
                                digitsOnly: true,
                                onCompleted: (String value) async {
                                  var url = Uri.http(REST_ENDPOINT,
                                      '/api/v1/users/twofactor/${widget._emailAddress}/$value');
                                  var response = await http.get(url);

                                  if (response.statusCode == 201 &&
                                      context.mounted) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeScreen()),
                                    );
                                  } else {
                                    setState(() {
                                      _codeColor = PRIMARY_RED;
                                      _attemptsLeft--;
                                      String att = _attemptsLeft == 1
                                          ? 'attempt'
                                          : 'attempts';
                                      _errorText =
                                          'Incorrect code. You have $_attemptsLeft $att left.';
                                    });
                                    if (_attemptsLeft == 0) {
                                      Navigator.of(context).pop();
                                    }
                                  }
                                },
                                onEditing: (bool value) {
                                  if (value) {
                                    setState(() {
                                      _codeColor = PRIMARY_GREEN;
                                      _errorText = '';
                                    });
                                  }
                                },
                              ),
                              Text(
                                _errorText,
                                style: const TextStyle(
                                    fontSize: 16, color: PRIMARY_RED),
                              )
                            ])))
              ])),
        ));
  }
}
