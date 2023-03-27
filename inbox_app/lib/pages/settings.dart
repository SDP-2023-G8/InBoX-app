import 'package:flutter/material.dart';
import 'package:inbox_app/main.dart';
import 'package:inbox_app/pages/forgot_password.dart';
import 'package:inbox_app/pages/homepage.dart';
import '../components/bars.dart';
import '../components/pop_ups.dart';
import '../constants/constants.dart';
import 'register.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _emailAdress =
      'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadddddddddddddddddddd@gmail.com'; // TODO: get from server
  bool _unitStatus = true; // TODO: pull from server

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
        return true;
      },
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
              appBar: const SimpleBar('Settings'),
              bottomNavigationBar: const BottomBar(2),
              body: CustomScrollView(slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 30, 20, 15),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Email address:',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20)),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            constraints: BoxConstraints.loose(
                                                const Size.fromWidth(200)),
                                            child: Text(
                                              _emailAdress,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                              textWidthBasis:
                                                  TextWidthBasis.longestLine,
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                          context) =>
                                                      const ChangeEmailDialog());
                                            },
                                            child: const Text('Change',
                                                style: TextStyle(fontSize: 20)),
                                          )
                                        ])
                                  ])),
                          const Divider(color: PRIMARY_GREY, thickness: 2),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Password (hidden)',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ForgotPasswordScreen()),
                                    );
                                  },
                                  child: const Text(
                                    'Change',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(color: PRIMARY_GREY, thickness: 2),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Your InBoX "Name here"',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          'Status: ${_unitStatus ? 'active' : 'inactive'}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 17)),
                                      ElevatedButton(
                                        onPressed: () {
                                          bool passwordCorrect = false;
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  VerifyWithPasswordDialog(
                                                      _unitStatus
                                                          ? 'Deactivate'
                                                          : 'Activate'));
                                          if (false)
                                            passwordCorrect =
                                                true; // TODO: check password and update passwordCorrect
                                          if (passwordCorrect)
                                            setState(() {
                                              _unitStatus = !_unitStatus;
                                            });
                                          // TODO: (de)activate the unit
                                        },
                                        child: Text(
                                          _unitStatus
                                              ? 'Deactivate'
                                              : 'Activate',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ]),
                              ],
                            ),
                          ),
                          const Divider(color: PRIMARY_GREY, thickness: 2),
                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        const DeleteAccountDialog());
                              },
                              child: const Text(
                                'Delete Account',
                                style:
                                    TextStyle(color: PRIMARY_RED, fontSize: 20),
                              ),
                            ),
                          ),
                          const Divider(color: PRIMARY_GREY, thickness: 2),
                        ],
                      ),
                      Container(
                          padding: const EdgeInsets.only(bottom: 20),
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: const Size(140, 50)),
                            onPressed: () {
                              // TODO: log the user out
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const StartScreen()),
                              );
                            },
                            child: const Text(
                              'Logout',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              ]))),
    );
  }
}
